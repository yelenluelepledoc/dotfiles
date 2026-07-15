# rebuild.ps1 — reproduce this environment on any Windows machine, no admin.
# Idempotent: safe to re-run any time you change config (like Kun's rebuild.sh).
# The repo is the source of truth; running this makes the live machine match it.

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path

# ----------------------------------------------------------------------------
# 1. Install Scoop if this is a fresh machine
# ----------------------------------------------------------------------------
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
$env:Path = "$env:USERPROFILE\scoop\shims;$env:Path"

# ----------------------------------------------------------------------------
# 2. Corporate TLS interception (e.g. Zscaler): make git + Node trust it
#    git  -> use the Windows cert store (schannel) instead of bundled OpenSSL
#    Node -> export the interception root(s) to a PEM and point NODE_EXTRA_CA_CERTS
# ----------------------------------------------------------------------------
git config --global http.sslBackend schannel

$certDir = Join-Path $repo 'certs'
$pem     = Join-Path $certDir 'interception-root.pem'
$roots = Get-ChildItem Cert:\CurrentUser\Root, Cert:\LocalMachine\Root,
                       Cert:\CurrentUser\CA,   Cert:\LocalMachine\CA -ErrorAction SilentlyContinue |
         Where-Object { $_.Subject -match 'Zscaler|Netskope|Forcepoint|BlueCoat|Palo Alto|Fortinet|McAfee|Umbrella|SSL Inspection|Decrypt' } |
         Sort-Object Thumbprint -Unique
if ($roots) {
  New-Item -ItemType Directory -Force $certDir | Out-Null
  $sb = [System.Text.StringBuilder]::new()
  foreach ($c in $roots) {
    [void]$sb.AppendLine('-----BEGIN CERTIFICATE-----')
    [void]$sb.AppendLine([Convert]::ToBase64String($c.RawData, 'InsertLineBreaks'))
    [void]$sb.AppendLine('-----END CERTIFICATE-----')
  }
  Set-Content -Path $pem -Value $sb.ToString() -Encoding ascii
  [Environment]::SetEnvironmentVariable('NODE_EXTRA_CA_CERTS', $pem, 'User')
  $env:NODE_EXTRA_CA_CERTS = $pem
  Write-Host "Configured NODE_EXTRA_CA_CERTS for $($roots.Count) interception root(s)." -ForegroundColor Cyan
}

# ----------------------------------------------------------------------------
# 3. Replay every package from the committed manifest
# ----------------------------------------------------------------------------
scoop bucket add extras     2>$null
scoop bucket add nerd-fonts 2>$null
scoop import (Join-Path $repo 'scoopfile.json')

# ----------------------------------------------------------------------------
# 4. Re-create all config links (junctions for dirs, hardlinks for files).
#    Self-healing: repairs a link even if a stale file/broken link exists.
# ----------------------------------------------------------------------------
function Link-Dir($link, $target) {
  if (Test-Path $link) {
    $i = Get-Item $link -Force
    if ($i.LinkType -eq 'Junction') { return }         # already a junction
    Rename-Item $link "$link.bak-$(Get-Date -f yyyyMMddHHmmss)"  # real dir: back up
  }
  New-Item -ItemType Directory -Force (Split-Path $link) | Out-Null
  New-Item -ItemType Junction -Path $link -Target $target | Out-Null
}
function Link-File($link, $target) {
  # A Windows hardlink doesn't record its source, and an atomic-save editor
  # can silently sever it. So: if the live file isn't byte-identical to the
  # repo copy, remove it and recreate the hardlink from the repo.
  if (Test-Path $link) {
    if ((Get-FileHash $link).Hash -eq (Get-FileHash $target).Hash -and (Get-Item $link).LinkType) { return }
    Remove-Item $link -Force
  }
  New-Item -ItemType Directory -Force (Split-Path $link) | Out-Null
  New-Item -ItemType HardLink -Path $link -Target $target | Out-Null
}

Link-Dir  "$env:USERPROFILE\.config\wezterm" (Join-Path $repo 'wezterm')
Link-Dir  "$env:LOCALAPPDATA\nvim"           (Join-Path $repo 'nvim')
Link-File $PROFILE                            (Join-Path $repo 'powershell\profile.ps1')
Link-File "$env:USERPROFILE\.config\starship.toml" (Join-Path $repo 'starship\starship.toml')
Link-File "$env:USERPROFILE\.claude\CLAUDE.md"     (Join-Path $repo 'agents.md')
Link-File "$env:USERPROFILE\.claude\settings.json" (Join-Path $repo 'claude\settings.json')

# ----------------------------------------------------------------------------
# 5. Claude Code — native installer (auto-updates in the background).
# ----------------------------------------------------------------------------
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
}

Write-Host "Rebuild complete. Restart WezTerm." -ForegroundColor Green

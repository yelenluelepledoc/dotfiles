# PSReadLine goodies — only in a real interactive terminal (skip when output
# is redirected/non-interactive, e.g. scripts, so it never errors)
if ([Environment]::UserInteractive -and -not [Console]::IsOutputRedirected) {
  # Ghost-text suggestions from history — Kun's zsh-autosuggestions
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
  Set-PSReadLineOption -PredictionViewStyle InlineView
  Set-PSReadLineOption -Colors @{ InlinePrediction = '#6e6a86' }

  # Ctrl+F accepts the suggestion — his exact keybind
  Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function AcceptSuggestion

  # Syntax highlighting is on by default in PSReadLine — nothing to enable
}

# Aliases: the few keystrokes saved that "add up"
Set-Alias g git
Set-Alias v nvim
function gs { git status }
function gd { git diff }
function ll { Get-ChildItem -Force }

# Default editor → Neovim
$env:EDITOR = 'nvim'

# Starship config location (Phase 5)
$env:STARSHIP_CONFIG = "$HOME/.config/starship.toml"

# Smart cd (zoxide) + prompt (Starship)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (&starship init powershell)

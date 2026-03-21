#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Tmux Config Installer
# ═══════════════════════════════════════════════════════════════
#
# USAGE:
#   git clone https://github.com/hoangtrung99/tmux-config.git /tmp/tmux-config
#   bash /tmp/tmux-config/install.sh
#
# WHAT THIS DOES:
#   1. Install tmux + dependencies (fzf, cargo)
#   2. Install TPM (Tmux Plugin Manager)
#   3. Symlink config files to ~/.tmux.conf, ~/.tmux/statusbar.conf, etc.
#   4. Install all 11 plugins via TPM
#   5. Add terminal cheatsheet to shell
#
# ═══════════════════════════════════════════════════════════════

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

# ─── Step 1: Install tmux ───
install_tmux() {
  if command -v tmux &>/dev/null; then
    ok "tmux already installed: $(tmux -V)"
    return
  fi
  info "Installing tmux..."
  if [[ "$(uname)" == "Darwin" ]]; then
    command -v brew &>/dev/null || fail "Homebrew not found. Install from https://brew.sh"
    brew install tmux
  elif command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y tmux
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y tmux
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm tmux
  else
    fail "Cannot detect package manager. Install tmux manually."
  fi
  ok "tmux installed: $(tmux -V)"
}

# ─── Step 2: Install dependencies ───
install_deps() {
  if ! command -v fzf &>/dev/null; then
    info "Installing fzf..."
    if [[ "$(uname)" == "Darwin" ]]; then
      brew install fzf
    elif command -v apt-get &>/dev/null; then
      sudo apt-get install -y fzf
    fi
    ok "fzf installed"
  else
    ok "fzf already installed"
  fi

  if ! command -v cargo &>/dev/null; then
    info "Installing Rust/Cargo (for tmux-thumbs)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env" 2>/dev/null || true
    ok "Cargo installed"
  else
    ok "Cargo already installed"
  fi
}

# ─── Step 3: Install TPM ───
install_tpm() {
  if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    ok "TPM already installed"
    return
  fi
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM installed"
}

# ─── Step 4: Link config files ───
link_configs() {
  info "Linking config files..."

  # Backup existing configs
  for f in ~/.tmux.conf ~/.tmux-help.txt ~/.tmux-cheatsheet.sh; do
    if [ -f "$f" ] && [ ! -L "$f" ]; then
      cp "$f" "${f}.bak.$(date +%s)"
      warn "Backed up $f"
    fi
  done

  # Symlink main files
  ln -sf "$REPO_DIR/tmux.conf" "$HOME/.tmux.conf"
  ln -sf "$REPO_DIR/statusbar.conf" "$HOME/.tmux/statusbar.conf"
  ln -sf "$REPO_DIR/tmux-help.txt" "$HOME/.tmux-help.txt"
  ln -sf "$REPO_DIR/tmux-cheatsheet.sh" "$HOME/.tmux-cheatsheet.sh"
  chmod +x "$HOME/.tmux-cheatsheet.sh"

  ok "Config files linked"
}

# ─── Step 5: Add cheatsheet to shell ───
setup_shell_cheatsheet() {
  local rc="$HOME/.zshrc"
  [ ! -f "$rc" ] && rc="$HOME/.bashrc"
  [ ! -f "$rc" ] && { warn "No .zshrc or .bashrc found, skipping cheatsheet"; return; }

  if grep -q "tmux-cheatsheet" "$rc" 2>/dev/null; then
    ok "Cheatsheet already in shell rc"
    return
  fi

  info "Adding cheatsheet to $rc..."
  echo '' >> "$rc"
  echo '# Tmux cheatsheet on terminal open (set TMUX_CHEATSHEET=off to disable)' >> "$rc"
  echo 'source ~/.tmux-cheatsheet.sh' >> "$rc"
  ok "Cheatsheet added to $rc"
}

# ─── Step 6: Install plugins ───
install_plugins() {
  info "Installing tmux plugins via TPM..."
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>&1
  ok "All plugins installed"

  if tmux list-sessions &>/dev/null; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null
    ok "Tmux config reloaded"
  fi
}

# ─── Main ───
main() {
  echo ""
  echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
  echo -e "${CYAN}         Tmux Config - Installation                ${NC}"
  echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
  echo ""

  install_tmux
  install_deps
  install_tpm
  link_configs
  setup_shell_cheatsheet
  install_plugins

  echo ""
  echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  Setup complete!${NC}"
  echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
  echo ""
  echo "  Start tmux:        tmux new -s main"
  echo "  Popup help:        C-b ?"
  echo "  Floating pane:     C-b p"
  echo "  Fuzzy find:        C-b F"
  echo "  Quick copy:        C-b Space"
  echo "  Save session:      C-b C-s"
  echo "  Restore session:   C-b C-r"
  echo ""
  echo "  Config repo:       $REPO_DIR"
  echo "  Edit status bar:   $REPO_DIR/statusbar.conf"
  echo ""
  echo "  Disable cheatsheet: export TMUX_CHEATSHEET=off"
  echo ""
}

main "$@"

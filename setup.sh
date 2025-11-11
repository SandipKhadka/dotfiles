#!/bin/bash

set -euo pipefail  # Exit on error, undefined variables, pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Check if we're on Fedora
check_fedora() {
    if [[ ! -f /etc/fedora-release ]]; then
        log_error "This script is intended for Fedora Linux only"
        exit 1
    fi
}

# Check for internet connectivity
check_internet() {
    log_info "Checking internet connectivity..."
    if ! curl -Is https://www.google.com | head -n 1 | grep -q "200"; then
        log_error "No internet connectivity. Please check your connection."
        exit 1
    fi
}

# Backup existing files
backup_files() {
    local files=("$HOME/.zshrc" "$HOME/.tmux.conf")
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
            log_info "Backing up $file to $backup"
            cp "$file" "$backup"
        fi
    done
}

# Update system
update_system() {
    log_info "Updating system packages..."
    if ! sudo dnf update -y; then
        log_error "Failed to update system packages"
        exit 1
    fi
    log_success "System updated successfully"
}

# Install packages
install_packages() {
    local packages=("git" "tmux" "zsh" "fzf")
    
    log_info "Installing packages: ${packages[*]}..."
    
    if ! sudo dnf install -y "${packages[@]}"; then
        log_error "Failed to install packages"
        exit 1
    fi
    log_success "Packages installed successfully"
}

# Install Oh My Zsh
install_ohmyzsh() {
    log_info "Installing Oh My Zsh..."
    
    # Check if ZSH is installed
    if ! command -v zsh >/dev/null 2>&1; then
        log_error "ZSH is not installed"
        exit 1
    fi
    
    # Check if Oh My Zsh is already installed
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_warning "Oh My Zsh is already installed. Skipping..."
        return 0
    fi
    
    # Install Oh My Zsh
    if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
        log_error "Failed to install Oh My Zsh"
        exit 1
    fi
    log_success "Oh My Zsh installed successfully"
}

# Install Zsh plugins
install_zsh_plugins() {
    local plugins=(
        "zsh-users/zsh-completions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
    )
    
    log_info "Installing Zsh plugins..."
    
    for plugin in "${plugins[@]}"; do
        local plugin_name=$(basename "$plugin")
        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
        
        if [[ -d "$plugin_dir" ]]; then
            log_warning "Plugin $plugin_name already exists. Skipping..."
            continue
        fi
        
        log_info "Installing $plugin..."
        if ! git clone "https://github.com/$plugin.git" "$plugin_dir"; then
            log_error "Failed to clone $plugin"
            continue
        fi
        log_success "Installed $plugin_name"
    done
}

# Clone dotfiles
clone_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    
    if [[ -d "$dotfiles_dir" ]]; then
        log_warning "Dotfiles directory already exists. Pulling latest changes..."
        if ! git -C "$dotfiles_dir" pull; then
            log_error "Failed to update existing dotfiles repository"
        fi
    else
        log_info "Cloning dotfiles..."
        if ! git clone https://github.com/SandipKhadka/dotfiles "$dotfiles_dir"; then
            log_error "Failed to clone dotfiles"
            return 1
        fi
    fi
    log_success "Dotfiles cloned/updated successfully"
}

# Change default shell to Zsh
change_shell() {
    local zsh_path=$(which zsh)
    
    if [[ -z "$zsh_path" ]]; then
        log_error "Zsh not found in PATH"
        return 1
    fi
    
    if [[ "$SHELL" == "$zsh_path" ]]; then
        log_info "Zsh is already the default shell"
        return 0
    fi
    
    log_info "Changing default shell to Zsh..."
    if ! chsh -s "$zsh_path"; then
        log_error "Failed to change shell to Zsh. You might need to run: chsh -s $(which zsh)"
        return 1
    fi
    log_success "Default shell changed to Zsh"
}

# Apply dotfiles (placeholder function - customize as needed)
apply_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    
    if [[ ! -d "$dotfiles_dir" ]]; then
        log_warning "Dotfiles directory not found. Skipping dotfiles application."
        return 1
    fi
    
    log_info "Applying dotfiles..."
    
    # Example: Link dotfiles
    if [[ -f "$dotfiles_dir/.zshrc" ]]; then
        ln -sf "$dotfiles_dir/.zshrc" "$HOME/.zshrc"
        log_success "Linked .zshrc"
    fi
    
    if [[ -f "$dotfiles_dir/.tmux.conf" ]]; then
        ln -sf "$dotfiles_dir/.tmux.conf" "$HOME/.tmux.conf"
        log_success "Linked .tmux.conf"
    fi
    
    # Add more dotfiles as needed
}

# Reload Zsh configuration
reload_zsh() {
    log_info "Reloading Zsh configuration..."
    if [[ -f "$HOME/.zshrc" ]]; then
        # Source zshrc in the current shell if we're in zsh
        if [[ -n "$ZSH_VERSION" ]]; then
            source "$HOME/.zshrc"
            log_success "Zsh configuration reloaded"
        else
            log_warning "Please restart your shell or run: source ~/.zshrc"
        fi
    else
        log_warning "No .zshrc file found to reload"
    fi
}

# Main execution
main() {
    log_info "Starting Fedora setup script..."
    
    # Pre-flight checks
    check_root
    check_fedora
    check_internet
    
    # Backup existing files
    backup_files
    
    # System setup
    update_system
    install_packages
    
    # Zsh setup
    install_ohmyzsh
    install_zsh_plugins
    change_shell
    
    # Dotfiles
    clone_dotfiles
    apply_dotfiles
    
    # Final steps
    reload_zsh
    
    log_success "Setup completed successfully!"
    log_info "Please log out and log back in for Zsh to become your default shell"
    log_info "Or run: exec zsh"
}

# Run main function
main "$@"

#!/data/data/com.termux/files/usr/bin/bash

# FormForge installer script

echo "FormForge Installer"
echo "=================="
echo ""

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "Error: This script must be run in Termux"
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
pkg update -y
pkg install -y openjdk-21 gradle git

# Create directories
echo "Setting up FormForge..."
INSTALL_DIR="$HOME/.local/share/formforge"
mkdir -p "$INSTALL_DIR"
mkdir -p "$HOME/.local/bin"

# Copy files
cp -r ./* "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/formforge"

# Create symlink
ln -sf "$INSTALL_DIR/formforge" "$HOME/.local/bin/formforge"

# Add to PATH if not already there
if ! grep -q ".local/bin" ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo ""
echo "✅ FormForge installed successfully!"
echo ""
echo "To start using FormForge:"
echo "1. Restart Termux or run: source ~/.bashrc"
echo "2. Run: formforge"
echo ""
echo "Happy app building! 🚀"
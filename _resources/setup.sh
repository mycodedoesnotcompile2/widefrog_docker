#!/bin/bash
set -eo pipefail

WIDEFROG_REPOSITORY="https://github.com/mycodedoesnotcompile2/widefrog_fork"
WIDEFROG_INSTALL_PATH="/opt/widefrog"

# Must run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Error: run this script as root (e.g. sudo $0)" >&2
    exit 1
fi

# Detect architecture
machine_arch="$(uname -m)"
if [ "$machine_arch" = "x86_64" ] || [ "$machine_arch" = "amd64" ]; then
    arch="x64"
elif [ "$machine_arch" = "aarch64" ] || [ "$machine_arch" = "arm64" ]; then
    arch="arm64"
else
    echo "[!] Error: unsupported architecture: $machine_arch" >&2
    exit 1
fi

echo "[+] Detected architecture: $arch"

# Configure download URLs
N_m3u8="https://github.com/nilaoda/N_m3u8DL-RE/releases/download/v0.6.0-beta/N_m3u8DL-RE_v0.6.0-beta_linux-${arch}_20260629.tar.gz"
SHAKA_PACKAGER="https://github.com/shaka-project/shaka-packager/releases/download/v3.9.3/packager-linux-${arch}"

# Download both files into /tmp
echo "[+] Downloading N_m3u8DL-RE..."
wget -q "$N_m3u8" -O "/tmp/n_m3u8dl-re.tar.gz"

echo "[+] Downloading Shaka Packager..."
wget -q "$SHAKA_PACKAGER" -O /tmp/packager-linux-"$arch"

# Extract N_m3u8DL-RE into a temporary directory
echo "[+] Installing N_m3u8DL-RE..."
mkdir -p /tmp/n_m3u8dl-extracted
tar -xzf /tmp/n_m3u8dl-re.tar.gz -C /tmp/n_m3u8dl-extracted

# Locate the executable inside the archive
n_m3u8_binary="$(find /tmp/n_m3u8dl-extracted -type f -name 'N_m3u8DL-RE' -print -quit)"
if [ -z "$n_m3u8_binary" ]; then
    echo "[!] Error: N_m3u8DL-RE binary not found in archive" >&2
    exit 1
fi
install -m 0755 "$n_m3u8_binary" "/usr/local/bin/N_m3u8DL-RE"

# Install Shaka Packager
echo "[+] Installing Shaka Packager..."
install -m 0755 /tmp/packager-linux-"$arch" "/usr/local/bin/shaka-packager"

# Clean up downloaded and extracted files
rm -rf "/tmp/n_m3u8dl-re.tar.gz" /tmp/packager-linux-"$arch" "/tmp/n_m3u8dl-extracted"

# Clone Widefrog
echo "[+] Cloning widefrog..."
git clone --depth=1 "$WIDEFROG_REPOSITORY" "$WIDEFROG_INSTALL_PATH"

# source bashrc
source "/root/.bashrc"

# Create Python virtual environment inside the repository
echo "[+] Creating Python virtual environment..."
#python3 -m venv "$WIDEFROG_VENV_PATH"
mkvirtualenv -p python3 venvwidefrog

echo "[+] Activating virtual environment..."
#. "$WIDEFROG_VENV_PATH/bin/activate"
workon venvwidefrog

# Enter Widefrog directory
cd "$WIDEFROG_INSTALL_PATH"

# Install requirements
echo "[+] Installing Python requirements..."
grep -v '^#' requirements.txt | xargs -n 1 pip install

# Make terminal scripts executable
echo "[+] Setting terminal scripts as executable..."
chmod +x terminal/*

# Launch Widefrog
echo "[+] Launching Widefrog..."
python widefrog.py

echo "[+] Installation complete!"
echo "[+] N_m3u8DL-RE: /usr/local/bin/N_m3u8DL-RE"
echo "[+] Shaka Packager: /usr/local/bin/shaka-packager"
echo "[+] widefrog location: $WIDEFROG_INSTALL_PATH"

#!/run/current-system/sw/bin/bash

# Source the profile to ensure environment variables are correctly set
source /etc/profile

# Debugging information
echo "Running in $(pwd)"
echo "Current shell: $SHELL"
echo "User: $USER"
echo "Home directory: $HOME"
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo "Script directory: $(dirname "$(realpath "$0")")"
echo "Files in script directory: $(ls -l $(dirname "$(realpath "$0")"))"
echo "Environment variables:"
env

# Get the directory of the current script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Check if the Python script exists
if [ ! -f "$SCRIPT_DIR/flasher.py" ]; then
  echo "Error: Python script not found at $SCRIPT_DIR/flasher.py"
  exit 1
fi

# Ensure `tkinter` and `lsblk` are available in the Nix environment and run the script
nix-shell --pure -p bash python3 python3Packages.tkinter util-linux --run "bash -c 'which lsblk; python3 $SCRIPT_DIR/flasher.py'"

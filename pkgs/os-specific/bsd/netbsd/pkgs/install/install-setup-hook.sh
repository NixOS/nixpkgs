addNetBSDInstallMakeFlags() {
  export INSTALL_FILE="install -U -c"
  export INSTALL_DIR="install -U -d"
  export INSTALL_LINK="install -U -l h"
  export INSTALL_SYMLINK="install -U -l s"
}

preConfigureHooks+=(addNetBSDInstallMakeFlags)

addNetBSDMakeFlags() {
  makeFlags="INCSDIR=${!outputDev}/include $makeFlags"
  makeFlags="MANDIR=${!outputMan}/share/man $makeFlags"
}

preConfigureHooks+=(addNetBSDMakeFlags)

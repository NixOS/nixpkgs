addNetBSDMakeFlags() {
  prependToVar makeFlags "INCSDIR=${!outputDev}/include"
  prependToVar makeFlags "MANDIR=${!outputMan}/share/man"
}

preConfigureHooks+=(addNetBSDMakeFlags)

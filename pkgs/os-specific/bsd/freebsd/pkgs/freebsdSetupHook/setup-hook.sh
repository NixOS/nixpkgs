setFreeBSDSrcTop() {
  makeFlags="SRCTOP=$BSDSRCDIR $makeFlags"
}

addFreeBSDMakeFlags() {
  makeFlags="SBINDIR=${!outputBin}/bin $makeFlags"
  makeFlags="LIBEXECDIR=${!outputLib}/libexec $makeFlags"
  makeFlags="INCLUDEDIR=${!outputDev}/include $makeFlags"
}

postUnpackHooks+=(setFreeBSDSrcTop)
preConfigureHooks+=(addFreeBSDMakeFlags)

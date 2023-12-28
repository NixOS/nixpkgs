setFreeBSDSrcTop() {
  makeFlags="SRCTOP=$BSDSRCDIR $makeFlags"
}

addFreeBSDMakeFlags() {
  makeFlags="SBINDIR=${!outputBin}/bin $makeFlags"
  makeFlags="LIBEXECDIR=${!outputLib}/libexec $makeFlags"
  makeFlags="LIBDATADIR=${!outputLib}/data $makeFlags"
  makeFlags="INCLUDEDIR=${!outputDev}/include $makeFlags"
  makeFlags="CONFDIR=${!outputBin}/etc $makeFlags"
}

postUnpackHooks+=(setFreeBSDSrcTop)
preConfigureHooks+=(addFreeBSDMakeFlags)

setFreeBSDSrcTop() {
  makeFlags="SRCTOP=$BSDSRCDIR $makeFlags"
}

addFreeBSDMakeFlags() {
  makeFlags="SBINDIR=${!outputBin}/bin $makeFlags"
  makeFlags="LIBEXECDIR=${!outputLib}/libexec $makeFlags"
  makeFlags="LIBDATADIR=${!outputLib}/data $makeFlags"
  makeFlags="INCLUDEDIR=${!outputDev}/include $makeFlags"
  makeFlags="CONFDIR=${!outputBin}/etc $makeFlags"
  makeFlags="MANDIR=${!outputMan}/share/man/man $makeFlags"

  if [ -n "$debug" ]; then
    makeFlags="DEBUGFILEDIR=${debug}/lib/debug $makeFlags"
  else
    makeFlags="DEBUGFILEDIR=${out}/lib/debug $makeFlags"
  fi

  echo $makeFlags
}

postUnpackHooks+=(setFreeBSDSrcTop)
preConfigureHooks+=(addFreeBSDMakeFlags)

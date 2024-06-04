addOpenBSDMakeFlags() {
  makeFlags="INCSDIR=${!outputDev}/include $makeFlags"
  makeFlags="MANDIR=${!outputMan}/share/man $makeFlags"
}

fixOpenBSDInstallDirs() {
  find "$BSDSRCDIR" -name Makefile -exec \
    sed -i -E \
      -e 's|/usr/include|${INCSDIR}|' \
      -e 's|/usr/bin|${BINDIR}|' \
      -e 's|/usr/lib|${LIBDIR}|' \
      {} \;
}

setBinownBingrp() {
  export BINOWN=$(id -u)
  export BINGRP=$(id -g)
}

preConfigureHooks+=(addOpenBSDMakeFlags)
postPatchHooks+=(fixOpenBSDInstallDirs setBinownBingrp)

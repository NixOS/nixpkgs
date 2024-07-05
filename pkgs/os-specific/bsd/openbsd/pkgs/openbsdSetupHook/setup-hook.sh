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

makeOpenBSDUnversionedLinks() {
  [[ -d "$out/lib" ]] || return 0
  pushd "$out/lib"
  local l
  for l in lib*.so.*; do
    l="${l//.so.*/}"
    [[ ! -f "$l.so" ]] || continue
    ln -s "$l".so.* "$l.so"
  done
  popd
}

preConfigureHooks+=(addOpenBSDMakeFlags)
postPatchHooks+=(fixOpenBSDInstallDirs setBinownBingrp)
preFixupHooks+=(makeOpenBSDUnversionedLinks)

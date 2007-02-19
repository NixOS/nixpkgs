source $stdenv/setup

postInstall=postInstall
postInstall() {
  ensureDir $out/lib
  ensureDir $out/include/pci
  cp lib/*.h $out/include/pci
  cp lib/libpci.a $out/lib
}

makeFlags="PREFIX=$out"

genericBuild

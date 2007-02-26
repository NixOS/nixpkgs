source $stdenv/setup

preBuild=preBuild
preBuild() {
  bunzip2 < $pciids > pci.ids
}

postInstall=postInstall
postInstall() {
  ensureDir $out/lib
  ensureDir $out/include/pci
  cp lib/*.h $out/include/pci
  cp lib/libpci.a $out/lib
}

makeFlags="PREFIX=$out"

genericBuild

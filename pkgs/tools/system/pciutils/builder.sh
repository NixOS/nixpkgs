source $stdenv/setup

preBuild=preBuild
preBuild() {
  bunzip2 < $pciids > pci.ids
}

makeFlags="PREFIX=$out $makeFlags"

genericBuild

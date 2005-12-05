source $stdenv/setup

preBuild() {
  kernelhash=$(ls $kernel/lib/modules)
  echo $kernelhash
  ln -s $kernel/lib/modules/$kernelhash/build linux
}

preBuild=preBuild

genericBuild

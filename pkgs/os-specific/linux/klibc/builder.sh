source $stdenv/setup

preBuild=preBuild
preBuild() {
  mkdir -p linux/include
  ln -s $kernel/lib/modules/*/build/include/* linux/include/
}

makeFlagsArray=(V=1 prefix=$out SHLIBDIR=$out/lib)

installFlagsArray=("${makeFlagsArray[@]}")

genericBuild

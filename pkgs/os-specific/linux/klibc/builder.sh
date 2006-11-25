source $stdenv/setup

preBuild=preBuild
preBuild() {
  mkdir -p linux/include
  ln -s $kernelHeaders/include/* linux/include/
}

makeFlagsArray=(V=1 prefix=$out SHLIBDIR=$out/lib)

installFlagsArray=("${makeFlagsArray[@]}")

genericBuild

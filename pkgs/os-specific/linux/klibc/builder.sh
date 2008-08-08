source $stdenv/setup

preBuild=preBuild
preBuild() {
    mkdir -p linux/include
    cp -prd $kernel/lib/modules/*/build/include/* linux/include/
    chmod -R u+w linux/include/
}

makeFlagsArray=(V=1 prefix=$out SHLIBDIR=$out/lib)

genericBuild

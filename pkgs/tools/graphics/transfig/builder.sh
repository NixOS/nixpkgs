source $stdenv/setup

patchPhase() {
    for i in $patches; do
        header "applying patch $i" 3
        patch -p0 < $i
        stopNest
    done

    configureImakefiles "s:__PREFIX_PNG:$libpng:"
    configureImakefiles "s:__PREFIX:$out:"
}

configureImakefiles() {
    local sedcmd=$1

    sed "${sedcmd}" fig2dev/Imakefile > tmpsed
    cp tmpsed fig2dev/Imakefile

    sed "${sedcmd}" fig2dev/dev/Imakefile > tmpsed
    cp tmpsed fig2dev/dev/Imakefile

    sed "${sedcmd}" transfig/Imakefile > tmpsed
    cp tmpsed transfig/Imakefile
}

buildPhase() {
    xmkmf
    make Makefiles
    make
}

preInstall() {
    mkdir -p $out
    mkdir -p $out/lib
}

genericBuild

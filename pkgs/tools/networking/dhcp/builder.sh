source $stdenv/setup

export DESTDIR=$out

configurePhase=configurePhase
configurePhase() {
    ./configure
    prefix=$out
}

preBuild=preBuild
preBuild() {
    substituteInPlace client/scripts/linux --replace /bin/bash $shell
}

genericBuild

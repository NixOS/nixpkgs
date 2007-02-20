source $stdenv/setup

export DESTDIR=$out

# Hack to prevent dhclient from overriding the PATH specified with
# '-e' on the command-line.
makeFlags="CLIENT_PATH='\"FAKE_PATH=/nothing\"'"

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

source $stdenv/setup

# Hack to prevent dhclient from overriding the PATH specified with
# '-e' on the command-line.
makeFlagsArray=(CLIENT_PATH='\"FAKE_PATH=/nothing\"' \
    USERBINDIR=$out/bin BINDIR=$out/sbin CLIENTBINDIR=$out/sbin \
    ADMMANDIR=$out/share/man/cat8 FFMANDIR=$out/share/man/cat5 \
    LIBMANDIR=$out/share/man/cat3 USRMANDIR=$out/share/man/cat1 \
    LIBDIR=$out/lib INCDIR=$out/include \
)

configurePhase=configurePhase
configurePhase() {
    ./configure
}

preBuild=preBuild
preBuild() {
    substituteInPlace client/scripts/linux --replace /bin/bash $shell
}

genericBuild

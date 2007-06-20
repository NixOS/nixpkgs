source $stdenv/setup

# Hack to prevent dhclient from overriding the PATH specified with
# '-e' on the command-line.
makeFlagsArray=(CLIENT_PATH='\"FAKE_PATH=/nothing\"' \
    USERBINDIR=$out/bin BINDIR=$out/sbin CLIENTBINDIR=$out/sbin \
    ADMMANDIR=$out/share/man/man8 FFMANDIR=$out/share/man/man5 \
    LIBMANDIR=$out/share/man/man3 USRMANDIR=$out/share/man/man1 \
    LIBDIR=$out/lib INCDIR=$out/include VARDB=$OUT/var/run \
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

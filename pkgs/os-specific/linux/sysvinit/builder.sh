source $stdenv/setup

makeFlagsArray=(LCRYPT=-lcrypt BIN_OWNER=$(id -u) BIN_GROUP=$(id -g) ROOT=$out)

preBuild="cd src"

preInstall=preInstall
preInstall() {
    substituteInPlace Makefile --replace /usr /
    mkdir $out
    mkdir $out/bin
    mkdir $out/sbin
    mkdir $out/include
    mkdir $out/share
    mkdir $out/share/man
    mkdir $out/share/man/man1
    mkdir $out/share/man/man5
    mkdir $out/share/man/man8
}

genericBuild

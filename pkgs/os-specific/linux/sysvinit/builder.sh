source $stdenv/setup

buildPhase() {
cd src
make
}

buildPhase=buildPhase

installPhase() {
mkdir $out
mkdir $out/bin
mkdir $out/sbin
mkdir $out/include
mkdir $out/share
mkdir $out/share/man
mkdir $out/share/man/man1
mkdir $out/share/man/man5
mkdir $out/share/man/man8
make ROOT=$out install
}

installPhase=installPhase

genericBuild

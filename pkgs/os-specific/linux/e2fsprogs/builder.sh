. $stdenv/setup

export NIX_GLIBC_FLAGS_SET=1

installPhase() {
   make install
   cd lib/uuid; make install
}

installPhase=installPhase

genericBuild

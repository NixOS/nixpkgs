. $stdenv/setup

installPhase() {
   make install
   cd lib/uuid; make install
}

installPhase=installPhase

genericBuild

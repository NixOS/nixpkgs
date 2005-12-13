source $stdenv/setup

installPhase() {
   make install-nokeys
}
installPhase=installPhase

genericBuild

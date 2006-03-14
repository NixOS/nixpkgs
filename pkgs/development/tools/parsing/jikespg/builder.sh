source $stdenv/setup

set -e

configurePhase=configurePhase
configurePhase() {
  tar zxvf $src 
  cd jikespg/src
}

installPhase=installPhase
installPhase() {
  ensureDir $out/bin
  cp jikespg $out/bin
}

genericBuild
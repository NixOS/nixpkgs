source $stdenv/setup

set -e

configurePhase() {
  tar zxvf $src 
  cd jikespg/src
}

installPhase() {
  ensureDir $out/bin
  cp jikespg $out/bin
}

genericBuild

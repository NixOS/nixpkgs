source $stdenv/setup

export ROOT=$out

buildPhase() {
  cd src
  make
}

buildPhase=buildPhase

installPhase() {
  make install
  cd ..; cp -af rc.d sysconfig ppp $ROOT/etc

}

installPhase=installPhase

genericBuild

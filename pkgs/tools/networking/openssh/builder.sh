source $stdenv/setup


configureFlags="--with-privsep-path=$out/empty"
 
installPhase() {
   make install-nokeys
}
installPhase=installPhase

genericBuild

source $stdenv/setup


if test -n "$xauth"; then
   configureFlags="--with-xauth=$xauth"
fi

installPhase() {
   make install-nokeys
}
installPhase=installPhase

genericBuild

buildinputs="$x11 $libpng $libjpeg $expat $freetype"
. $stdenv/setup

if test -z "$x11"; then 
    configureFlags="$configureFlags --without-x"
fi

genericBuild

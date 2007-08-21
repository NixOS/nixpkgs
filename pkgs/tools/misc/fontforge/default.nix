{ stdenv, fetchurl, gettext, freetype, zlib
, libungif, libpng, libjpeg, libtiff, libxml2
}:

stdenv.mkDerivation {
  name = "fontforge-20070808";
  
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/fontforge/fontforge_full-20070808.tar.bz2;
    sha256 = "1b3x5djn9ifvszwmgwmn1jwl50pbq6fzvbmgx0qjg0m60m3v44nx";
  };

  preConfigure = "
    unpackFile ${freetype.src}
    freetypeSrcPath=$(echo `pwd`/freetype-*)
    configureFlags=\"$configureFlags --with-freetype-src=$freetypeSrcPath\"
  ";

  buildInputs = [gettext freetype zlib libungif libpng libjpeg libtiff libxml2];
}

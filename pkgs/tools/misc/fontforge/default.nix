{ stdenv, fetchurl, gettext, freetype, zlib
, libungif, libpng, libjpeg, libtiff, libxml2
, libX11 ? null, lib, xproto ? null, libXt ? null
}:

stdenv.mkDerivation {
  name = "fontforge-20070808";
  
  src = fetchurl {
    url = mirror://sourceforge/fontforge/fontforge_full-20070808.tar.bz2;
    sha256 = "1b3x5djn9ifvszwmgwmn1jwl50pbq6fzvbmgx0qjg0m60m3v44nx";
  };
    
  configureFlags = if libX11 != null then "--with-gui=gdraw" else "";
  
  preConfigure = ''
    unpackFile ${freetype.src}
    freetypeSrcPath=$(echo `pwd`/freetype-*)
    configureFlags="$configureFlags --with-freetype-src=$freetypeSrcPath"
    
    substituteInPlace configure \
      --replace /usr/include /no-such-path \
      --replace /usr/lib /no-such-path \
      --replace /usr/local /no-such-path \
  '';

  buildInputs =
    [gettext freetype zlib libungif libpng libjpeg libtiff libxml2]
    ++ lib.optional (libX11 != null) libX11
    ++ lib.optional (xproto != null) xproto
    ++ lib.optional (libXt != null) libXt
    ;
}

{ stdenv, fetchurl, gettext, freetype, zlib
, libungif, libpng, libjpeg, libtiff, libxml2
, withX11 ? false
, libX11 ? null, lib, xproto ? null, libXt ? null
}:

let 
  version = "20110222";
  name = "fontforge-${version}";
in

stdenv.mkDerivation {
  inherit name;
  
  src = fetchurl {
    url = "mirror://sourceforge/fontforge/fontforge_full-${version}.tar.bz2";
    sha256 = "0gj342iyd2qmza523r84m65fm7bymcfd4lbllywbfjzq4s0838lg";
  };
    
  configureFlags = lib.optionalString withX11 "--with-gui=gdraw";
  
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
    [ gettext freetype zlib libungif libpng libjpeg libtiff libxml2 ]
    ++ lib.optionals withX11 [ libX11 xproto libXt ];
}

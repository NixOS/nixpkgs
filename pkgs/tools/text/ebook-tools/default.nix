{ stdenv, fetchurl, cmake, pkgconfig, libxml2, libzip }:

stdenv.mkDerivation rec {
  name = "ebook-tools-0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/ebook-tools/${name}.tar.gz";
    sha256 = "1bi7wsz3p5slb43kj7lgb3r6lb91lvb6ldi556k4y50ix6b5khyb";
  };

  buildInputs = [ cmake pkgconfig libxml2 libzip ];

  preConfigure = 
    ''
      NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libzip)"
    '';

  meta = {
    homepage = "http://ebook-tools.sourceforge.net";
    description = "Tools and library for dealing with various ebook file formats";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}

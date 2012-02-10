{ stdenv, fetchurl, cmake, pkgconfig, libxml2, libzip }:

stdenv.mkDerivation rec {
  name = "ebook-tools-0.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/ebook-tools/${name}.tar.gz";
    sha256 = "0wgwdsd3jwwfg36jyr5j0wayqjli3ia80lxzk10byd4cmkywnhy2";
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

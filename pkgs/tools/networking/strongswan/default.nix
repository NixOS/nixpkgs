{ stdenv, fetchurl, gmp, pkgconfig }:

stdenv.mkDerivation rec {
  name = "strongswan-5.2.1";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "05cjjd7gg65bl6fswj2r2i13nn1nk4x86s06y75gwfdvnlrsnlga";
  };

  buildInputs = [ gmp pkgconfig ];

  configureFlags = [ "--enable-swanctl" "--enable-cmd" ];

  NIX_LDFLAGS = "-lgcc_s" ;

  meta = {
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    description = "OpenSource IPsec-based VPN Solution";
    homepage = https://www.strongswan.org;
    license = stdenv.lib.licenses.gpl2Plus;
    inherit (stdenv.gcc.gcc.meta) platforms;
  };
}

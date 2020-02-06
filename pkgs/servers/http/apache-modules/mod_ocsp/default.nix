{ stdenv, fetchurl, pkgconfig, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
  pname = "mod_ocsp";
  version = "0.2.1";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "1vwgai56krdf8knb0mgy07ni9mqxk82bcb4gibwpnxvl6qwgv2i0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ mod_ca apr aprutil ];
  inherit (mod_ca) configureFlags installFlags;

  meta = with stdenv.lib; {
    description = "RedWax CA service modules of OCSP Online Certificate Validation";

    homepage = "https://redwax.eu";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}

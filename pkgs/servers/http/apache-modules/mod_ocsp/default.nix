{ stdenv, fetchurl, pkgconfig, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
  pname = "mod_ocsp";
  version = "0.2.2";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "0wy5363m4gq1w08iny2b3sh925bnznlln88pr9lgj9vgbn8pqnrn";
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

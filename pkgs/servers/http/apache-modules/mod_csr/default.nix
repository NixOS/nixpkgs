{ stdenv, fetchurl, pkgconfig, mod_ca, apr, aprutil }:


stdenv.mkDerivation rec {
  pname = "mod_csr";
  version = "0.2.3";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "1p4jc0q40453wpvwqgnr1n007b4jxpkizzy3r4jygsxxgg4x9w7x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ mod_ca apr aprutil ];
  inherit (mod_ca) configureFlags installFlags;

  meta = with stdenv.lib; {
    description = "RedWax CA service module to handle Certificate Signing Requests";

    homepage = "https://redwax.eu";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}

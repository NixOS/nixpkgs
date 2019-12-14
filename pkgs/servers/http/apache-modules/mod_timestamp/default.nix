{ stdenv, fetchurl, pkgconfig, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
  pname = "mod_timestamp";
  version = "0.2.1";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "0j4b04dbdwn9aff3da9m0lnqi0qbw6c6hhi81skl15kyc3vzp67f";
  };

  buildInputs =[mod_ca pkgconfig apr aprutil];
  inherit(mod_ca) configureFlags installFlags;

  meta = with stdenv.lib; {
    description = "RedWax CA service module for issuing signed timestamps";

    inherit(mod_ca.meta) license platforms maintainers homepage;
  };
}

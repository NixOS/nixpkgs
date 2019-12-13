{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca}:

stdenv.mkDerivation rec {
 name = "mod_timestamp";

 meta = with stdenv.lib; {
   description = "RedWax CA service module for issuing signed timestamps.";
   version = "0.2.1";

   inherit (mod_ca.meta) license platforms maintainers homepage;
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "0j4b04dbdwn9aff3da9m0lnqi0qbw6c6hhi81skl15kyc3vzp67f";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 inherit ( mod_ca ) configurePlatforms configureFlags installPhase; 
}



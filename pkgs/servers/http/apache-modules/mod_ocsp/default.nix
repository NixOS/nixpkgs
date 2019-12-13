{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_ocsp";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules of OCSP Online Certificate Validation";
   version = "0.2.1";

   inherit (mod_ca.meta) license platforms maintainers homepage;
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "1vwgai56krdf8knb0mgy07ni9mqxk82bcb4gibwpnxvl6qwgv2i0";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 inherit ( mod_ca ) configurePlatforms configureFlags installPhase; 
}



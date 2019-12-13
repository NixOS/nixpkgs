{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_csr";

 meta = with stdenv.lib; {
    description = "RedWax CA service module to handle Certificate Signing Requests.";
    version = "0.2.1";

    inherit (mod_ca.meta) license platforms maintainers homepage;
 };
 
 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "01sdvv07kchdd6ssrmd2cbhj50qh2ibp5g5h6jy1jqbzp0b3j9ja";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 preBuild = "cp ${./openssl_setter_compat.h} openssl_setter_compat.h";

 inherit ( mod_ca ) configurePlatforms configureFlags installPhase; 
}



{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
 name = "mod_crl";

 meta = with stdenv.lib; {
    description = "RedWax module for Certificate Revocation Lists";
    version = "0.2.1";

    inherit (mod_ca.meta) license platforms maintainers homepage;
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "0k6iqn5a4bqdz3yx6d53f1r75c21jnwhxmmcq071zq0361xjzzj6";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 inherit ( mod_ca ) configurePlatforms configureFlags installPhase; 
}

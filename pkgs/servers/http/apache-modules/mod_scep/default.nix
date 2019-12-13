{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap , apr, aprutil, mod_ca}:

stdenv.mkDerivation rec {
 name = "mod_scep";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules for SCEP (Automatic ceritifcate issue/renewal)";
   version = "0.2.1";

   inherit (mod_ca.meta) license platforms maintainers homepage;
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "14l8v6y6kx5dg8avb5ny95qdcgrw40ss80nqrgmw615mk7zcj81f";
 };

 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 inherit ( mod_ca ) configurePlatforms configureFlags installPhase; 

 preBuild = "cp ${./openssl_setter_compat.h} openssl_setter_compat.h";
}



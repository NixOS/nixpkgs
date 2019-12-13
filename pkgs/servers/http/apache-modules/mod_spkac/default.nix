{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap , apr, aprutil, mod_ca}:

stdenv.mkDerivation rec {
 name = "mod_spkac";

 meta = with stdenv.lib; {
   description = "RedWax CA service module for handling the Netscape keygen requests. ";
   version = "0.2.1";

   inherit (mod_ca.meta) license platforms maintainers homepage;
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "0x6ia9qcr7lx2awpv9cr4ndic5f4g8yqzmp2hz66zpzkmk2b2pyz";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 inherit ( mod_ca ) configurePlatforms configureFlags installPhase; 
}



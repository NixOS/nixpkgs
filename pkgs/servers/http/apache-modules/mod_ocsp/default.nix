{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_ocsp";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules of OCSP Online Certificate Validation";
   version = "0.2.1";
   homepage = mod_ca.homepage;
   license = licenses.asl20;
   platforms = platforms.unix;
   maintainers = with maintainers; [ dirkx ];
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "1vwgai56krdf8knb0mgy07ni9mqxk82bcb4gibwpnxvl6qwgv2i0";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



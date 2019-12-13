{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_pkcs12";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules for PKCS#12 format files";
   version = "0.2.1";
   homepage = mod_ca.homepage;
   license = licenses.asl20;
   platforms = platforms.unix;
   maintainers = with maintainers; [ dirkx ];
 };

 src = fetchurl {
   url = "${mod_ca.baseurl}${name}-${meta.version}${mod_ca.suffix}";
   sha256 = "0by4qfjs3a8q0amzwazfq8ii6ydv36v2mjga0jzc9i6xyl4rs6ai";
 };

 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



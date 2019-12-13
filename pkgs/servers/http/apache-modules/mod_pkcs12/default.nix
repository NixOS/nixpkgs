{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_pkcs12";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules for PKCS#12 format files";
   suffix = ".tar.gz";

   baseurl = "https://redwax.eu/dist/rs/";
   homepage = "https://redwax.eu";

   license = licenses.asl20;

   maintainers = with maintainers; [ dirkx ];

   version = "0.2.1";

   # This propably should be a wildcard - as we build on all
   # current NixOS platforms.
   # platforms = [ platforms.linux platforms.darwin ];
 };

 src = fetchurl {
   url = "${meta.baseurl}${name}-${meta.version}${meta.suffix}";
   sha256 = "0by4qfjs3a8q0amzwazfq8ii6ydv36v2mjga0jzc9i6xyl4rs6ai";
 };

 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap }:

stdenv.mkDerivation rec {
 name = "mod_ca";

 meta = with stdenv.lib; {
   baseurl = "https://redwax.eu/dist/rs/";
   suffix = ".tar.gz";

   description = "RedWax CA service modules.";
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
   sha256 = "1pxapjrzdsk2s25vhgvf56fkakdqcbn9hjncwmqh0asl1pa25iic";
 };

 buildInputs = [ gnused coreutils pkgconfig apacheHttpd openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];

 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



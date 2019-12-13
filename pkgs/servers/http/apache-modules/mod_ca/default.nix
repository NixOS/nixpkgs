{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap }:

stdenv.mkDerivation rec {
 baseurl = "https://redwax.eu/dist/rs/";
 name = "mod_ca";
 suffix = ".tar.gz";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules.";
   version = "0.2.1";

   homepage = "https://redwax.eu";
   license = licenses.asl20;
   platforms = platforms.unix;
   maintainers = with maintainers; [ dirkx ];
 };

 src = fetchurl {
   url = "${baseurl}${name}-${meta.version}${suffix}";
   sha256 = "1pxapjrzdsk2s25vhgvf56fkakdqcbn9hjncwmqh0asl1pa25iic";
 };

 buildInputs = [ gnused coreutils pkgconfig apacheHttpd openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];

 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



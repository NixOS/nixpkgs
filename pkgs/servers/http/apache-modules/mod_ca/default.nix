{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap }:

stdenv.mkDerivation rec {
 baseurl = "https://redwax.eu/dist/rs/";
 name = "mod_ca";

 meta = with stdenv.lib; {
   suffix = ".tar.gz";

   description = "RedWax CA service modules.";
   homepage = "https://redwax.eu";

   license = licenses.asl20;

   maintainers = with maintainers; [ dirkx ];

   version = "0.2.1";
   platforms = platforms.unix;
 };

 src = fetchurl {
   url = "${baseurl}${name}-${meta.version}${meta.suffix}";
   sha256 = "1pxapjrzdsk2s25vhgvf56fkakdqcbn9hjncwmqh0asl1pa25iic";
 };

 buildInputs = [ gnused coreutils pkgconfig apacheHttpd openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];

 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



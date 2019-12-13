{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap , apr, aprutil, mod_ca}:

stdenv.mkDerivation rec {
 name = "mod_scep";

 meta = with stdenv.lib; {
   description = "RedWax CA service modules for SCEP (Automatic ceritifcate issue/renewal)";
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

   sha256 = "14l8v6y6kx5dg8avb5ny95qdcgrw40ss80nqrgmw615mk7zcj81f";
 };
 preBuild = "cp ${./openssl_setter_compat.h} openssl_setter_compat.h";
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];
 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



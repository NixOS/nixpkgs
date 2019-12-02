{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap , apr, aprutil, mod_ca}:

stdenv.mkDerivation rec {
 name = "mod_scep";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service modules for SCEP (Automatic ceritifcate issue/renewal)";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
 };

 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_scep/trunk";
   sha256 = "0b5np7mbfbczi8vmil9gy5rlh268idmz7p053rwy90v26y6wd8vv";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca}:

stdenv.mkDerivation rec {
 name = "mod_timestamp";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service module for issuing signed timestamps.";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
 };

 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_timestamp/trunk";
   sha256 = "1gdd3vq4w8d6ppkwavpj6q1z21wmyzvjfb2sg2dkbkz1rs2bgfcx";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



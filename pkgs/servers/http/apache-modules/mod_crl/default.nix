{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
 name = "mod_crl";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service module to handle Certificate Revocation Lists.";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
 };

 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_crl/trunk";
   sha256 = "0z9pvv8c10w9rrm29i1zn4vmvxnj525f9xpyy6pyrn26ijbs91qv";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}

{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_pkcs12";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service modules for PKCS#12 format files";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
 };

 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_pkcs12/trunk";
   sha256 = "0ph88f3n0x7fdxdgv9vbmxxij7hy3gipf96vbp4546b9zr2fs6b8";
 };

 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



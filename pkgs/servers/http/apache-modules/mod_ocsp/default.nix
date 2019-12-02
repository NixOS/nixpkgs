{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:
with import <nixpkgs> {};

stdenv.mkDerivation rec {
 name = "mod_ocsp";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service modules of OCSP Online Certificate Validation";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
 };

 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_ocsp/trunk";
   sha256 = "1qai3gcq3mdxqlycd3yns1p2kz0lbwl43573cr98hmrmgwzbwy9c";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



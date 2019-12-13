{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_csr";

 meta = with stdenv.lib; {
    description = "RedWax CA service module to handle Certificate Signing Requests.";
    baseurl = "https://redwax.eu/dist/rs/";
    suffix = ".tar.gz";
    homepage = "https://redwax.eu";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
    version = "0.2.1";
 };

 src = fetchurl {
   url = "${meta.baseurl}${name}-${meta.version}${meta.suffix}";
   sha256 = "01sdvv07kchdd6ssrmd2cbhj50qh2ibp5g5h6jy1jqbzp0b3j9ja";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 preBuild = "cp ${./openssl_setter_compat.h} openssl_setter_compat.h";

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];

 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



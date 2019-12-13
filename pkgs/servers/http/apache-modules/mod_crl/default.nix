{ stdenv, fetchurl, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
 name = "mod_crl";

 meta = with stdenv.lib; {
    description = "RedWax CA service module to handle Certificate Revocation Lists.";
    baseurl = "https://redwax.eu/dist/rs/";
    suffix = ".tar.gz";
    homepage = "https://redwax.eu";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
    version = "0.2.1";
 };

 src = fetchurl {
   url = "${meta.baseurl}${name}-${meta.version}${meta.suffix}";
   sha256 = "0k6iqn5a4bqdz3yx6d53f1r75c21jnwhxmmcq071zq0361xjzzj6";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];
 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}

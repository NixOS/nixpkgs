{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap, apr, aprutil, mod_ca }:

stdenv.mkDerivation rec {
 name = "mod_csr";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service module to handle Certificate Signing Requests.";
    license = licenses.asl20;
    maintainers = with maintainers; [ dirkx ];
 };
 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_csr/trunk";
   sha256 = "07fnswqxlv40kbj35vqhimk2qhwm01lky7y7z302hc1h14x2cn9z";
 };
 buildInputs = [ mod_ca gnused coreutils pkgconfig apacheHttpd apr aprutil openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];

 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



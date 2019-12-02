{ stdenv, fetchsvn, gnused, coreutils, pkgconfig, apacheHttpd, openssl, openldap }:

stdenv.mkDerivation rec {
 name = "mod_ca";

 meta = with stdenv.lib; {
    homepage = "https://redwax.eu";
    description = "RedWax CA service modules.";
    license = licenses.asl20;
    # platforms = [ platforms.linux platforms.darwin ];
    maintainers = with maintainers; [ dirkx ];
 };

 src = fetchsvn {
   url = "https://source.redwax.eu/svn/redwax/rs/mod_ca/trunk";
   sha256 = "0llyx7wwdmw2pychg5396whzvfdvrk6q3kd25sw0fciwbw0hrr99";
 };

 buildInputs = [ gnused coreutils pkgconfig apacheHttpd openssl openldap ];

 configurePlatforms = [];
 configureFlags = [
       "--with-apxs=${apacheHttpd.dev}/bin/apxs"
	];

 installPhase = "make INCLUDEDIR=$out/include LIBEXECDIR=$out/libexec install";
}



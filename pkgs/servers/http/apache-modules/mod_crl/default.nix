{ stdenv, fetchurl, pkgconfig, mod_ca, apr, aprutil }:


stdenv.mkDerivation rec {
  pname = "mod_crl";
  version = "0.2.3";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "1x186kp6fr8nwg0jlv5phagxndvw4rjqfga9mkibmn6dx252p61d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ mod_ca apr aprutil ];
  inherit (mod_ca) configureFlags installFlags;

  meta = with stdenv.lib; {
    description = "RedWax module for Certificate Revocation Lists";

    homepage = "https://redwax.eu";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}

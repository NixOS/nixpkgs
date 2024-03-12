{ lib, stdenv, fetchurl, pkg-config, mod_ca, apr, aprutil }:

stdenv.mkDerivation rec {
  pname = "mod_spkac";
  version = "0.2.2";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "0hpr58yazbi21m0sjn22a8ns4h81s4jlab9szcdw7j9w9jdc7j0h";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ mod_ca apr aprutil ];
  inherit (mod_ca) configureFlags installFlags;

  meta = with lib; {
    description = "RedWax CA service module for handling the Netscape keygen requests. ";

    homepage = "https://redwax.eu";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}

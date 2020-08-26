{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "mkrand-0.1.0";

  src = fetchurl {
    url = "https://github.com/mknight-tag/MKRAND/releases/download/v0.1.0/mkrand-0.1.0.tar.gz";
    sha256 = "1irwyv2j5c3606k3qbq77yrd65y27rcq3jdlp295rz875q8iq9fs";
  };

  doCheck = true;

  meta = {
    description = "A Digital Random Bit Generator";
    longDescription = "MKRAND is a utility for generating random information.";
    homepage = "https://github.com/mknight-tag/MKRAND/";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
  }

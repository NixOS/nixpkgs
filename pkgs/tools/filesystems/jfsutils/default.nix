{ stdenv, fetchurl, libuuid }:

stdenv.mkDerivation rec {
  name = "jfsutils-1.1.15";

  src = fetchurl {
    url = "http://jfs.sourceforge.net/project/pub/${name}.tar.gz";
    sha1 = "291e8bd9d615cf3d27e4000117c81a3602484a50";
  };

  buildInputs = [ libuuid ];

  meta = {
    description = "IBM JFS utilities";
  };
}

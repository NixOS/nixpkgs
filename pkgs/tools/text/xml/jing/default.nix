{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "jing-20030619";
  builder = ./unzip-builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/jing-20030619.zip;
    md5 = "f9b0775d8740f16ab3df82ad3707a093";
  };

  inherit unzip;
}
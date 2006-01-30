{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.1.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/sed-4.1.4.tar.gz;
    md5 = "2a62ceadcb571d2dac006f81df5ddb48";
  };
}

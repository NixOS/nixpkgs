{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "noweb-2.10c";
  src = fetchurl {
    url = http://nixos.org/tarballs/noweb-20060201.tar.gz;
    md5 = "b4813c6bc0bab9004e57edc1d7e57638";
  };
  builder = ./builder.sh;
}

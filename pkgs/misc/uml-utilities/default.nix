{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "uml-utilities-20040114";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/uml_utilities_20040114.tar.bz2;
    md5 = "1fd5b791ef32c6a3ed4ae42c4a53a316";
  };
}

{stdenv, fetchurl, j2sdk}:

stdenv.mkDerivation {

  name = "jakarta-tomcat-5.0.27";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/jakarta-tomcat-5.0.27.tar.gz;
    md5 = "b802ee042677e284bcf65738c7bdc3b6";
  };

  sdk = j2sdk;
}



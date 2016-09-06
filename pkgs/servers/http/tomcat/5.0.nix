{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "jakarta-tomcat-5.0.27";

  builder = ./builder.sh;

  src = fetchurl {
    url = https://archive.apache.org/dist/tomcat/tomcat-5/archive/v5.0.27/bin/jakarta-tomcat-5.0.27.tar.gz;
    md5 = "b802ee042677e284bcf65738c7bdc3b6";
  };

  inherit jdk;
}



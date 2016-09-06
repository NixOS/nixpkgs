{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "jakarta-tomcat-5.0.27";

  builder = ./builder.sh;

  src = fetchurl {
    url = https://archive.apache.org/dist/tomcat/tomcat-5/archive/v5.0.27/bin/jakarta-tomcat-5.0.27.tar.gz;
    sha256 = "0y3xfzb3wch359c6w0a2npxbj3vasrmr5jlvws8m08qn8d5wjgw7";
  };

  inherit jdk;
}



{ stdenv, fetchurl }:

let version = "6.0.29"; in

stdenv.mkDerivation rec {
  name = "apache-tomcat-${version}";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-6/v${version}/bin/${name}.tar.gz";
    sha256 = "0v96wmd4fnk3qskw32k8mb77f7yssqqinsrf9sir672l5ggmmcjc";
  };

  installPhase =
    ''
      mkdir $out
      mv * $out
    '';

  meta = {
    homepage = http://tomcat.apache.org/;
    description = "An implementation of the Java Servlet and JavaServer Pages technologies";
  };
}

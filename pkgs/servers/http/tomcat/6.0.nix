{ stdenv, fetchurl }:

let version = "6.0.39"; in

stdenv.mkDerivation rec {
  name = "apache-tomcat-${version}";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-6/v${version}/bin/${name}.tar.gz";
    sha256 = "19qix6affhc252n03smjf482drg3nxd27shni1gvhphgj3zfmgfy";
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

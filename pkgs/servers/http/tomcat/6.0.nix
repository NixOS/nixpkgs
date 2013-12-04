{ stdenv, fetchurl }:

let version = "6.0.37"; in

stdenv.mkDerivation rec {
  name = "apache-tomcat-${version}";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-6/v${version}/bin/${name}.tar.gz";
    sha256 = "000v63amhbyp8nkw3a4pff1vm4nxri5n9j7rknhnqaxzab3sp49y";
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

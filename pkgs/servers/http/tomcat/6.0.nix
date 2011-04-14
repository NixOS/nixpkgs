{ stdenv, fetchurl }:

let version = "6.0.32"; in

stdenv.mkDerivation rec {
  name = "apache-tomcat-${version}";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-6/v${version}/bin/${name}.tar.gz";
    sha256 = "505e649d1ffcf746e66be8295c8244a2949349dedf678e9f2a659c4736968c5e";
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

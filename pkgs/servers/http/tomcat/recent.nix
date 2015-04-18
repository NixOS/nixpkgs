{ versionMajor, versionMinor, sha256 }:
{ stdenv, fetchurl }:

let version = "${versionMajor}.${versionMinor}"; in

stdenv.mkDerivation rec {
  name = "apache-tomcat-${version}";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-${versionMajor}/v${version}/bin/${name}.tar.gz";
    inherit sha256;
  };

  installPhase =
    ''
      mkdir $out
      mv * $out
    '';

  meta = {
    homepage = http://tomcat.apache.org/;
    description = "An implementation of the Java Servlet and JavaServer Pages technologies";
    platforms = with stdenv.lib.platforms; all;
  };
}

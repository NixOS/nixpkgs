{stdenv, fetchurl, jdk}:

let version = "5.5.36"; in

stdenv.mkDerivation {

  name = "jakarta-tomcat-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "https://archive.apache.org/dist/tomcat/tomcat-5/v${version}/bin/apache-tomcat-${version}.tar.gz";
    sha256 = "01mzvh53wrs1p2ym765jwd00gl6kn8f9k3nhdrnhdqr8dhimfb2p";
  };

  inherit jdk;
}



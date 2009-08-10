{stdenv, fetchurl, apacheHttpd, jdk}:

stdenv.mkDerivation {
  name = "tomcat-connectors-1.2.28";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://mirror.hostfuss.com/apache/tomcat/tomcat-connectors/jk/source/jk-1.2.28/tomcat-connectors-1.2.28-src.tar.gz;
    sha256 = "0vzy864ky5374fwsxm9kcyybwc8asb8r4civnlhl2x90sg7dv3w9";
  };

  inherit apacheHttpd;
  buildInputs = [apacheHttpd jdk];
}

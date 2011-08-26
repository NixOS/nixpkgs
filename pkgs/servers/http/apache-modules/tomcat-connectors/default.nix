{stdenv, fetchurl, apacheHttpd, jdk}:

stdenv.mkDerivation {
  name = "tomcat-connectors-1.2.32";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.xl-mirror.nl//tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.32-src.tar.gz;
    sha256 = "1dim62warzy1hqvc7cvnqsbq475sr6vpgwd6gfmddmkgw155saji";
  };

  inherit apacheHttpd;
  buildInputs = [apacheHttpd jdk];
}

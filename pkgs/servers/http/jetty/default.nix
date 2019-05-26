{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-${version}";
  version = "9.4.16.v20190411";
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    name = "jetty-distribution-${version}.tar.gz";
    sha256 = "0vkcm68cp7z45pgfg5maxcxfjwy4xj30f2d0c7cfnw9d38wf5lpq";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.ini start.jar $out
  '';

  meta = {
    description = "A Web server and javax.servlet container";
    homepage = http://www.eclipse.org/jetty/;
    platforms = stdenv.lib.platforms.all;
    license = [ stdenv.lib.licenses.asl20 stdenv.lib.licenses.epl10 ];
  };
}

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-${version}";
  version = "9.4.12.v20180830";
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    name = "jetty-distribution-${version}.tar.gz";
    sha256 = "1z498cxvp1llp4ii8g52rhicypay1v2b6mmdmxrj3d82az6biiq3";
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

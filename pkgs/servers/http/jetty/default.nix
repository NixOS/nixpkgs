{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-${version}";
  version = "9.3.10.v20160621";

  src = fetchurl {
    url = "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    name = "jetty-distribution-${version}.tar.gz";
    sha256 = "0xqv7bp82i95gikma70kyi91nlgsj5zabzg59ly9ga4mqf5y0zbz";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.jar $out
  '';

  meta = {
    description = "A Web server and javax.servlet container";
    homepage = http://www.eclipse.org/jetty/;
    platforms = stdenv.lib.platforms.all;
    license = [ stdenv.lib.licenses.asl20 stdenv.lib.licenses.epl10 ];
  };
}

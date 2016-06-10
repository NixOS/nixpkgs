{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-${version}";
  version = "9.3.9.v20160517";

  src = fetchurl {
    url = "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    name = "jetty-distribution-${version}.tar.gz";
    sha256 = "0yqzcv4mj9wj8882jssf8ylh6s3jhgylrqxfggbn102dw05pppqs";
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

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-${version}";
  version = "9.4.8.v20171121";
  src = fetchurl {
    url = "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    name = "jetty-distribution-${version}.tar.gz";
    sha256 = "0bvwi70vdk468yqgvgq99lwrpy2y5znrl0b1cr8j6ygmsgnvvmjh";
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

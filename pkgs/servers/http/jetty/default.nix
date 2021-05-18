{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jetty";
  version = "9.4.41.v20210516";
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    sha256 = "sha256-hFQC1UiqZbbvyMf1FC3eqvVga3QdPWh0fbotatkVHBI=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.ini start.jar $out
  '';

  meta = {
    description = "A Web server and javax.servlet container";
    homepage = "https://www.eclipse.org/jetty/";
    platforms = stdenv.lib.platforms.all;
    license = [ stdenv.lib.licenses.asl20 stdenv.lib.licenses.epl10 ];
  };
}

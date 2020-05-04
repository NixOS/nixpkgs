{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jetty";
  version = "9.4.26.v20200117";
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    name = "jetty-distribution-${version}.tar.gz";
    sha256 = "0wgh7vap0h6gkz6pk8iycvhwmybyxv25ssinwxxrnzk8jg25g89i";
  };

  phases = [ "unpackPhase" "installPhase" ];

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

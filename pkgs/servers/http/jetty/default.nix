{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jetty";
  version = "9.4.39.v20210325";
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    sha256 = "0mn3ranh599w946cnykj7sbkj4w7ddpdhly7njmalsgabfbk8qv5";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.ini start.jar $out
  '';

  meta = with lib; {
    description = "A Web server and javax.servlet container";
    homepage = "https://www.eclipse.org/jetty/";
    platforms = platforms.all;
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ emmanuelrosa ];
  };
}

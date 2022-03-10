{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jetty";
  version = "9.4.45.v20220203";
  src = fetchurl {
    url = "mirror://maven/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz";
    sha256 = "sha256-wmM03qAnNsiEDsLkWyJKZIb3SPCRGCxTsgKBWwopMAw=";
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

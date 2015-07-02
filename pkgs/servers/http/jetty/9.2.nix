{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-9.2.5";

  src = fetchurl {
    url = "http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.2.11.v20150529.tar.gz&r=1";
    name = "jetty-distribution-9.2.11.v20150529.tar.gz";
    sha256 = "1d9s9l64b1l3x6vkx8qwgzfqwm55iq5g9xjjm2h2akf494yx1mrd";
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

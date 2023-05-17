{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jetty";
  version = "11.0.14";
  src = fetchurl {
    url = "mirror://maven/org/eclipse/jetty/jetty-home/${version}/jetty-home-${version}.tar.gz";
    sha256 = "sha256-lmS9B5dXJAc9j/RVs2sqMRaj1C5CN2trTszUXfPfHI4=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.jar $out
  '';

  meta = with lib; {
    description = "A Web server and javax.servlet container";
    homepage = "https://www.eclipse.org/jetty/";
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ emmanuelrosa ];
  };
}

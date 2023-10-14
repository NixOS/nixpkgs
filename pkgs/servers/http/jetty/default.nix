{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jetty";
  version = "12.0.1";
  src = fetchurl {
    url = "mirror://maven/org/eclipse/jetty/jetty-home/${version}/jetty-home-${version}.tar.gz";
    hash = "sha256-7nCai6S3eNly83aUQf0tiLTe+k3ih0cJnGqQvi143LI=";
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

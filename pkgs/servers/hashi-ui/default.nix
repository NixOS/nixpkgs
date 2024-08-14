{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hashi-ui";
  version = "1.3.8";

  src = fetchurl {
    url = "https://github.com/jippi/hashi-ui/releases/download/v${version}/hashi-ui-linux-amd64";
    sha256 = "999a34b6e99657ffc7e6c98a15b8ea744c28420e891a8802c7d99b737752dfb6";
  };

  dontUnpack = true;
  sourceRoot = ".";

  installPhase = ''
    install -m755 -D $src $out/bin/hashi-ui
  '';

  meta = with lib; {
    homepage = "https://github.com/jippi/hashi-ui";
    description = "Modern user interface for hashicorp Consul & Nomad";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ numkem ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    mainProgram = "hashi-ui";
  };
}

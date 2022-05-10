{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "tart";
  version = "0.32.1";

  src = fetchzip {
    url = "https://github.com/cirruslabs/${pname}/releases/download/${version}/${pname}.tar.gz";
    sha256 = "sha256-FzBs8SiWJnceEa16Koj3DpXO96Bjxl/k5YNb/8rp8aI=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 tart -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS VMs on Apple Silicon to use in CI and other automations";
    homepage = "https://github.com/cirruslabs/tart";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ techknowlogick ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "tart";
  version = "1.5.0";

  src = fetchzip {
    url = "https://github.com/cirruslabs/${pname}/releases/download/${version}/${pname}.tar.gz";
    sha256 = "sha256-TdpCeCTpVNoCGSJVvQ+cH+HBhS3dagofKKPj/wn3VlM=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin
    cp -r tart.app $out/Applications
    ln -s ../Applications/tart.app/Contents/MacOS/tart $out/bin/tart
    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS VMs on Apple Silicon to use in CI and other automations";
    homepage = "https://github.com/cirruslabs/tart";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dhess Enzime ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

{ lib
, fetchurl
, stdenvNoCC
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-amd64";
    x86_64-darwin = "darwin-amd64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  }.${system} or throwSystem;

  hash = {
    x86_64-linux = "sha256-ChrkpYWCF7zQN2ER0oeArzOSrM2ntt5btuAfyPTxGZE=";
    x86_64-darwin = "sha256-3L68SXFcc92QjNfkXWsk7eElXCdg0XNe42Dx4WFq6vY=";
    aarch64-linux = "sha256-BUryu2njZ4ZPCqKInrQDsQHGNRLFRidLy/Qc3LHLJ0c=";
    aarch64-darwin = "sha256-YyMR2lbCXTspw9TBimTfRpfEKMvYrTl4LrLtn8hEbpw=";
  }.${system} or throwSystem;
in stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mailpit";
  version = "1.7.0";

  setSourceRoot = "sourceRoot=`pwd`";

  src = fetchurl {
    url = "https://github.com/axllent/mailpit/releases/download/v${finalAttrs.version}/mailpit-${plat}.tar.gz";
    inherit hash;
  };

  postInstall = ''
    mkdir -p $out/bin
    cp mailpit $out/bin
  '';

  meta = with lib; {
    description = "An email and SMTP testing tool with API for developers";
    homepage = "https://github.com/axllent/mailpit";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    changelog = "https://github.com/axllent/mailpit/releases/tag/v${version}";
    maintainers = with maintainers; [ shyim ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})

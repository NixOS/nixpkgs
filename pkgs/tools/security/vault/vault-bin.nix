{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.16.1";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        i686-linux = "linux_386";
        x86_64-darwin = "darwin_amd64";
        aarch64-darwin = "darwin_arm64";
      };
      sha256 = selectSystem {
        x86_64-linux = "sha256-s520fOri0caLMeMmNaGS3+Y9I9dcXtNtiRtwrvj1pvA=";
        aarch64-linux = "sha256-12yFC3uPyqv2kQIv2KC+skXMrdU+IZir5z62JRtKBMs=";
        i686-linux = "sha256-LGkRnI5rZ8j6Fm1FBKiTUJNK8dUF9154OlNEHIsT36Q=";
        x86_64-darwin = "sha256-V7uLlQhsRQ36jtbIsdPfU3LvM41xDO3pj97KOlZWSYg=";
        aarch64-darwin = "sha256-QGxg11DR1LbRzRE2CqyGSWvus1IXIECbtamONrqcBVc=";
      };
    in
    fetchzip {
      url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_${suffix}.zip";
      inherit sha256;
    };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  installPhase = ''
    runHook preInstall
    install -D vault $out/bin/vault
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/vault --help
    $out/bin/vault version
    runHook postInstallCheck
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    description = "A tool for managing secrets, this binary includes the UI";
    homepage = "https://www.vaultproject.io";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsl11;
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man techknowlogick mkaito ];
    mainProgram = "vault";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
  };
}

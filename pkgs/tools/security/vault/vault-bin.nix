{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.15.3";

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
        x86_64-linux = "sha256-rRXpRxuslOvvNgK6W0BG/LWs2sAGGCuSxcbVbsmrtN0=";
        aarch64-linux = "sha256-vD/S+aZGa+JFRBV9WML9WbhrFpB8FynM62ZJ0zkWtDU=";
        i686-linux = "sha256-Y9KpL0kZxlgfkBSyXJVSND2hSJ1y+FuXKPK0/P2YX2w=";
        x86_64-darwin = "sha256-i85GQSJK7dPoLP7XBrz7CiISCG8KbGylL++ecy/CXRY=";
        aarch64-darwin = "sha256-eZAuUNbigJ/kye8p3yu+Qf+p47IkxKJntR2sGFpM+j8=";
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

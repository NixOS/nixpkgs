{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.13.7";

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
        x86_64-linux = "sha256-SdTcfUPTQYDJKe9V+ycKl0X/r3V2MgOev6zk6e4qDjw=";
        aarch64-linux = "sha256-+f6shcorp1wEbUVqq3WHQRZN+GUAmWocmvjq3btFo30=";
        i686-linux = "sha256-eJim5d+p3vXs0dUCABh6CVlrno+E2+j0RqPk4ozQm/g=";
        x86_64-darwin = "sha256-QvdN7l2/ZCGtLAhoXNBcE6uCrXsx/7CAcIuvvyBaM0Q=";
        aarch64-darwin = "sha256-s2A9EE5GO2aV/FRdDObRgBdwY+0YhacFxzPZs4FMwA8=";
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
    license = licenses.mpl20;
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man techknowlogick mkaito ];
    mainProgram = "vault";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
  };
}

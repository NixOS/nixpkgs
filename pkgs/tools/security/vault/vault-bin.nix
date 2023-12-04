{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.15.2";

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
        x86_64-linux = "sha256-aawDrQu8wEZqJ/uyCJjtWcgy8Ut34B5P+odqddE5P3M=";
        aarch64-linux = "sha256-thLVw//yIgPCAV9CdrRlINLg+cO5aB279I2aboZMF6w=";
        i686-linux = "sha256-bUhtnQB5YZdDuB4uondln0D3itoTr+1FaqjgTiT76WA=";
        x86_64-darwin = "sha256-+wZrWwbpibtCla1ydhDnLJsHrVymLzEXVE1KftZ+pOs=";
        aarch64-darwin = "sha256-2FGiCzIAEyXTqRaKEDZK5d/PWl4EmvJl9NieiOdgOeY=";
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

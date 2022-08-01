{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.10.5";

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
        x86_64-linux = "sha256-/tOaKSXx+rnpp0HWjCqgdZtaZZJruyNmWohPdijl2wI=";
        aarch64-linux = "sha256-nGjVhzhxIfrEkxCf0SQ6pojgM/ZR9ySmSNXsj+3ZA/o=";
        i686-linux = "sha256-ec8w2Y4nNYD8ELJauZFd8k3gdTU3wxoxALaL6kjnhKY=";
        x86_64-darwin = "sha256-ubEFX1MX767CTfjnAhU/0SV3n6Rz+YJSoVmXph6Iw0Q=";
        aarch64-darwin = "sha256-dxK7nGWi+2TCc9EcY8HJ2bcEFHmYGzAXCJ0rAvSCMeo=";
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
    license = licenses.mpl20;
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man techknowlogick ];
    mainProgram = "vault";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
  };
}

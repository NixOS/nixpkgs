{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.10.4";

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
        x86_64-linux = "sha256-cLCRZDOMx1bk+sZnArR9oOxuCowqFDwPINxWnONIqUU=";
        aarch64-linux = "sha256-5MdszdDr+qK1RZnhXnAZjZ9+pal3ju6XMV6NnjVSUIg=";
        i686-linux = "sha256-srlyVhh4j005kLdLdJoEjHbXw0DLHH4G/rUH+b4EdDE=";
        x86_64-darwin = "sha256-Bep4LAm1/8PDA+fiWfR0nDUezP0VADKwry2rjYv8dTU=";
        aarch64-darwin = "sha256-2mLIOun03SiXeSEFD+qRPOCj4LJB6LjB6aneJ78A5OQ=";
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
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man techknowlogick ];
    mainProgram = "vault";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
  };
}

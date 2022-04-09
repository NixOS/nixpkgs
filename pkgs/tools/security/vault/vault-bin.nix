{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc, fetchzip }:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.10.0";

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
        x86_64-linux = "sha256-enD/JcOmeavvUd/njbu7IksAqp9dKepVdYPkLJHA8OQ=";
        aarch64-linux = "sha256-FDkgUqFEVJoSED/FWqOXa4BTO6AYwkLS2iZh+BkzlqA=";
        i686-linux = "sha256-XUTWB5Ynu92SMP9Nt/0jAki6til4upKv1sdFzPbWxiw=";
        x86_64-darwin = "sha256-QNCsbIza56NqSU7R6+Cx//WBXiEOz6CEMCjrx4AR1x8=";
        aarch64-darwin = "sha256-LBgd8gqeU92336kypSIwMtKo7I1qB/RP2dNoIGJgq7k=";
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
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    license = licenses.mpl20;
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man techknowlogick ];
  };
}

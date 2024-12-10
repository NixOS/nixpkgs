{
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.15.4";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        x86_64-darwin = "darwin_amd64";
        aarch64-darwin = "darwin_arm64";
      };
      sha256 = selectSystem {
        x86_64-linux = "sha256-43Q69Pp5NLB4fITy2X8d0XHp5EX+gFLnwtHOontISoU=";
        aarch64-linux = "sha256-z87peCBv50eJr/kiFWPZUOeb0WCN4X+0JnxCvn3lCXo=";
        x86_64-darwin = "sha256-SAhlZNGq5rkNitKVd+EjLOeeTErhWg14tHFG4Bsexv8=";
        aarch64-darwin = "sha256-2DJgOdgJY6eUR2sqWS47vNjdkQGXOEEsSXhZeUBZxxs=";
      };
    in
    fetchzip {
      url = "https://releases.hashicorp.com/boundary/${version}/boundary_${version}_${suffix}.zip";
      inherit sha256;
    };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D boundary $out/bin/boundary
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/boundary --help
    $out/bin/boundary version
    runHook postInstallCheck
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;
  dontStrip = true;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://boundaryproject.io/";
    changelog = "https://github.com/hashicorp/boundary/blob/v${version}/CHANGELOG.md";
    description = "Enables identity-based access management for dynamic infrastructure";
    longDescription = ''
      Boundary provides a secure way to access hosts and critical systems
      without having to manage credentials or expose your network, and is
      entirely open source.

      Boundary is designed to be straightforward to understand, highly scalable,
      and resilient. It can run in clouds, on-prem, secure enclaves and more,
      and does not require an agent to be installed on every end host.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsl11;
    maintainers = with maintainers; [
      jk
      techknowlogick
    ];
    platforms = platforms.unix;
    mainProgram = "boundary";
  };
}

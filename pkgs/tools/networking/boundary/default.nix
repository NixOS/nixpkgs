{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.10.3";

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
        x86_64-linux = "sha256-MflcfTX0Ap8KEP0NDSZMHKM+fPsCoorUcUHV3WDXmBE=";
        aarch64-linux = "sha256-WeSmRpi50dfnv5quLPQTYNKQcQlBwno1iwPUyTeJrW4=";
        x86_64-darwin = "sha256-Ff4mu/g2K1wAeBj2IpOMT80gKcIP/dZjhWA8czokpxc=";
        aarch64-darwin = "sha256-Ove3Tgj7FnR5ZTzVZlmFDRoUaVlO2xA6CzMqIdobZxQ=";
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ jk techknowlogick ];
  };
}

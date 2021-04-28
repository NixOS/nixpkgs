{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.2.0";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      suffix = {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        x86_64-darwin = "darwin_amd64";
      }.${system} or (throw "Unsupported system: ${system}");
      fetchsrc = version: sha256: fetchzip {
        url = "https://releases.hashicorp.com/boundary/${version}/boundary_${version}_${suffix}.zip";
        sha256 = sha256.${system};
      };
    in
    fetchsrc version {
      x86_64-linux = "sha256-4h1Lx+Et1AfX75Cn0YUhV4MkEtzP6ICqAHVKex3PBpg=";
      aarch64-linux = "sha256-i7gzv8GdDgikPT1tMia4xltEYiIZ/VNRbAiGF2o8oKA=";
      x86_64-darwin = "sha256-tleIY1loPE61n59Qc9CJeropRUvTBbcIA8xmB1SaMt8=";
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}

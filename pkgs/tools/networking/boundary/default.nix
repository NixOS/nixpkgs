{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.12.2";

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
        x86_64-linux = "sha256-8JqteVRGT5UT1AgZeBMFjpTZOU/4/6/ZcJxdWcqU5G8=";
        aarch64-linux = "sha256-msVbtcBfDFOjU7BebbtEV05LjBdWDlI1Q/8YEwMbyq0=";
        x86_64-darwin = "sha256-ZXz0y6GvoCpeKcPJXV0t828fBBfeFAO+zmUAqCIOysU=";
        aarch64-darwin = "sha256-4xnM7k5i4XssQQ6Y0h2hq9s4TLnuazhqXiGQMhR4HNU=";
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ jk techknowlogick ];
    platforms = platforms.unix;
  };
}

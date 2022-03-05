{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.7.5";

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
        x86_64-linux = "sha256-wqNeeEQhR8cj7Gpbzp7UQV0j+w0peo41uKqgK9BoLH4=";
        aarch64-linux = "sha256-HK/6eMBWUW1IbYE5RpInhcQuIw16X9vQEZmOBje9Yzk=";
        x86_64-darwin = "sha256-ghgkPlEN9DHFviQzcGS/+oG+9Qqy2AfJ2IEyiSMJwwY=";
        aarch64-darwin = "sha256-F4iOCxAm8s34KktuS5PRPkIg9A0179H6zlOM3OuTyUw=";
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ jk techknowlogick ];
  };
}

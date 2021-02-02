{ stdenv, lib, fetchzip }:

let
  inherit (stdenv.hostPlatform) system;
  suffix = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    x86_64-darwin = "darwin_amd64";
  }."${system}" or (throw "Unsupported system: ${system}");
  fetchsrc = version: sha256: fetchzip {
      url = "https://releases.hashicorp.com/boundary/${version}/boundary_${version}_${suffix}.zip";
      sha256 = sha256."${system}";
    };
in
stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.1.4";

  src = fetchsrc version {
    x86_64-linux = "sha256-+YGXSyaGhfNk+T5P7wCqsNEYwpV/Oet7kOM8OPC1A6I=";
    aarch64-linux = "sha256-tikxRBF2Y+urv7S1EUu2d60twZWox1pI96yYX357r8o=";
    x86_64-darwin = "sha256-N+6iiybnWZkruhUe9TRcGaq5xES/iHzlEVGcghT4EUc=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D boundary $out/bin/boundary
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;

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

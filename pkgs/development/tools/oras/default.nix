{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oras";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras";
    rev = "v${version}";
    sha256 = "sha256-8QmMC4eB7WNxfEsVRUzv/gb7QmNBvcgDEENa1XxpCug=";
  };
  vendorSha256 = "sha256-THqrGnJnNDL6BJpRxeNLPjWB+SEUMUhiVOcJZDTM6n8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/oras-project/oras/internal/version.Version=${version}"
    "-X github.com/oras-project/oras/internal/version.BuildMetadata="
    "-X github.com/oras-project/oras/internal/version.GitTreeState=clean"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/oras --help
    $out/bin/oras version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://oras.land/";
    changelog = "https://github.com/oras-project/oras/releases/tag/v${version}";
    description = "The ORAS project provides a way to push and pull OCI Artifacts to and from OCI Registries";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}

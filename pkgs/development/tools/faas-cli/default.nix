{ lib, stdenv, buildGoModule, fetchFromGitHub }:
let
  faasPlatform = platform:
    let cpuName = platform.parsed.cpu.name; in {
      "aarch64" = "arm64";
      "armv7l" = "armhf";
    }.${cpuName} or cpuName;
in
buildGoModule rec {
  pname = "faas-cli";
  # When updating version change rev.
  version = "0.13.13";
  rev = "72816d486cf76c3089b915dfb0b66b85cf096634";
  platform = faasPlatform stdenv.targetPlatform;

  src = fetchFromGitHub {
    owner = "openfaas";
    repo = "faas-cli";
    rev = version;
    sha256 = "0mmrakyy2qmkldld7pxf5bx6whdadq2r52b68f9p9z7yqrdimix8";
  };

  CGO_ENABLED = 0;

  vendorSha256 = null;

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/openfaas/faas-cli/version.GitCommit=${rev}"
    "-X github.com/openfaas/faas-cli/version.Version=${version}"
    "-X github.com/openfaas/faas-cli/commands.Platform=${platform}"
  ];

  meta = with lib; {
    homepage = "https://github.com/openfaas/faas-cli";
    description = "Official CLI for OpenFaaS ";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki ];
  };
}

{ lib, stdenv, buildGoModule, fetchFromGitHub }:
let
  faasPlatform = platform:
    let cpuName = platform.parsed.cpu.name; in {
      "aarch64" = "arm64";
      "armv7l" = "armhf";
      "armv6l" = "armhf";
    }.${cpuName} or cpuName;
in
buildGoModule rec {
  pname = "faas-cli";
  # When updating version change rev.
  version = "0.13.15";
  rev = "b562392b12a78a11bcff9c6fca5a47146ea2ba0a";

  src = fetchFromGitHub {
    owner = "openfaas";
    repo = "faas-cli";
    rev = version;
    sha256 = "15kjxn0p8nz8147vsm9q5q6wr2w5ssybvn247kynj2n7139iva2f";
  };

  CGO_ENABLED = 0;

  vendorSha256 = null;

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/openfaas/faas-cli/version.GitCommit=${rev}"
    "-X github.com/openfaas/faas-cli/version.Version=${version}"
    "-X github.com/openfaas/faas-cli/commands.Platform=${faasPlatform stdenv.targetPlatform}"
  ];

  meta = with lib; {
    homepage = "https://github.com/openfaas/faas-cli";
    description = "Official CLI for OpenFaaS ";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
      "armv6l-linux"
    ];
  };
}

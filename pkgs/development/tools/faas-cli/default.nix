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
  version = "0.14.2";
  rev = "b1c09c0243f69990b6c81a17d7337f0fd23e7542";

  src = fetchFromGitHub {
    owner = "openfaas";
    repo = "faas-cli";
    rev = version;
    sha256 = "sha256-OdFd4q5IHu4FjNArcqVt4dNyLWegR4GdAyyCzgNIU+Q=";
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

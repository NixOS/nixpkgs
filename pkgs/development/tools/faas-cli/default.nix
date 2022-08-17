{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
}:
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
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "openfaas";
    repo = "faas-cli";
    rev = version;
    sha256 = "sha256-nHpsScpVQhSoqvNZ+xTv2cA3lV1MyPZAgNLZRuyvksE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = null;

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/openfaas/faas-cli/version.GitCommit=ref/tags/${version}"
    "-X github.com/openfaas/faas-cli/version.Version=${version}"
    "-X github.com/openfaas/faas-cli/commands.Platform=${faasPlatform stdenv.targetPlatform}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/faas-cli" \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/openfaas/faas-cli";
    description = "Official CLI for OpenFaaS ";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki techknowlogick ];
  };
}

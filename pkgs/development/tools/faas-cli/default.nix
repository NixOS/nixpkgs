{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
, installShellFiles
, testers
, faas-cli
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
  version = "0.16.36";

  src = fetchFromGitHub {
    owner = "openfaas";
    repo = "faas-cli";
    rev = version;
    sha256 = "sha256-5wvVwUj4JqHHZ/Q7s65nlCYENgHENma3IuUsNwcNJ9M=";
  };

  vendorHash = null;

  CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/openfaas/faas-cli/version.GitCommit=ref/tags/${version}"
    "-X github.com/openfaas/faas-cli/version.Version=${version}"
    "-X github.com/openfaas/faas-cli/commands.Platform=${faasPlatform stdenv.hostPlatform}"
  ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  postInstall = ''
    wrapProgram "$out/bin/faas-cli" \
      --prefix PATH : ${lib.makeBinPath [ git ]}

    installShellCompletion --cmd metal \
      --bash <($out/bin/faas-cli completion --shell bash) \
      --zsh <($out/bin/faas-cli completion --shell zsh)
  '';

  passthru.tests.version = testers.testVersion {
    command = "${faas-cli}/bin/faas-cli version --short-version --warn-update=false";
    package = faas-cli;
  };

  meta = with lib; {
    description = "Official CLI for OpenFaaS";
    mainProgram = "faas-cli";
    homepage = "https://github.com/openfaas/faas-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki techknowlogick ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
, testers
, trdl-client
}:

buildGoModule rec {
  pname = "trdl-client";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "trdl";
    rev = "v${version}";
    hash = "sha256-mmhbcBNHvx14Ihzq8UemPU8oYi/Gn3NK0FDZRVJvvfQ=";
  };

  sourceRoot = "source/client";

  vendorHash = "sha256-3B4MYj1jlovjWGIVK233t+e/mP8eEdHHv2M3xXSHaaM=";

  subPackages = [ "cmd/trdl" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/trdl/client/pkg/trdl.Version=${src.rev}"
  ];

  tags = [
    "dfrunmount"
    "dfssh"
  ];

  # There are no tests for cmd/trdl.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = trdl-client;
    command = "trdl version";
    version = "v${version}";
  };

  meta = with lib; {
    description = ''
      The universal solution for delivering your software updates securely from
      a trusted The Update Framework (TUF) repository
    '';
    longDescription = ''
      trdl is an Open Source solution providing a secure channel for delivering
      updates from the Git repository to the end user.

      The project team releases new versions of the software and switches them
      in the release channels. Git acts as the single source of truth while
      Vault is used as a tool to verify operations as well as populate and
      maintain the TUF repository.

      The user selects a release channel, continuously receives the latest
      software version from the TUF repository, and uses it.
    '';
    homepage = "https://trdl.dev";
    changelog = "https://github.com/werf/trdl/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "trdl";
  };
}

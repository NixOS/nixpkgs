{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, xorg
, darwin
, testers
, src-cli
}:

buildGoModule rec {
  pname = "src-cli";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-sN6Ea1kJce8Jqy8YrkWzDrQDrmA8F+UYz7ZuqfdbnJ4=";
  };

  vendorHash = "sha256-A533f+FfEzU2TlNwHkD8gjeQYRATz85cCCmqLdl9290=";

  subPackages = [
    "cmd/src"
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    xorg.libX11
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    version = testers.testVersion {
      package = src-cli;
      command = "src version || true";
    };
  };

  meta = with lib; {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "src";
  };
}

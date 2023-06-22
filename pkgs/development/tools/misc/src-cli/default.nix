{ lib
, buildGoModule
, fetchFromGitHub
, testers
, src-cli
}:

buildGoModule rec {
  pname = "src-cli";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-KqCH4f9QPfr/Hm4phR9qeCV925RkOawGnbCx8wz/QwE=";
  };

  vendorHash = "sha256-NMLrBYGscZexnR43I4Ku9aqzJr38z2QAnZo0RouHFrc=";

  subPackages = [
    "cmd/src"
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

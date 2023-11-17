{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.22.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-RlwHaLW27Y6yRzlvFLpJhOkPa1dYoX87XxMKecoT/dE=";
  };

  vendorHash = "sha256-9h7AocnhfYecEQbvesuFwXm+cTSd5lS9kdWjjO0GZP4=";

  doCheck = false;

  subPackages = [
    "cmd/benthos"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/benthosdev/benthos/v4/internal/cli.Version=${version}"
  ];

  meta = with lib; {
    description = "Fancy stream processing made operationally mundane";
    homepage = "https://www.benthos.dev";
    changelog = "https://github.com/benthosdev/benthos/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}

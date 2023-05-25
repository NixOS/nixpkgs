{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-RqfTDE4dcVUegiaHsJMm9z9WV2dxFpgT/5LlM5105Oc=";
  };

  vendorHash = "sha256-jfRmzCrw0qZJqt9tHkr/FmLWEAc911Z1hmk+nc6Lyb4=";

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

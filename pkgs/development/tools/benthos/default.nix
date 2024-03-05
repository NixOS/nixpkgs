{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.24.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-cZhx/a6bTOMP7JKM7ZnMzUEe5R79TIrVpv+6y/9qR0U=";
  };

  vendorHash = "sha256-6JEFToCBdfdS9MluApkEOcktWU66PpAD07Y9BKSzGx4=";

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

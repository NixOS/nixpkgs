{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.19.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-C/dExBN+ZBE8o3L0RBgYe4griFhv/Yd2I10em2UK/nQ=";
  };

  vendorHash = "sha256-33eY+jF12lYSO1Fqm1hRLKA1+aMNxe0c9gqNl2wf10I=";

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

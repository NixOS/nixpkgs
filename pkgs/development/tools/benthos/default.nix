{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.26.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-xFh0dmiLkU/o14OCefARtvkdN4Z1hzMfamyyB/mhf9s=";
  };

  proxyVendor = true;

  vendorHash = "sha256-bnQn6gdHhbUJUPWU3CKrw1sq5CL0Tkss4DINPwlsiPU=";

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
    mainProgram = "benthos";
    homepage = "https://www.benthos.dev";
    changelog = "https://github.com/benthosdev/benthos/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.39.0";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-jHtG0pVvM4zSgHDuL2fmRAcKVR2eoXSBo0luvHLyPr8=";
  };

  proxyVendor = true;

  vendorHash = "sha256-LCw15Q/kr5XCoBAOyGVOCcD/FcqUodlYLETNsRbOeG8=";

  doCheck = false;

  subPackages = [
    "cmd/benthos"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/redpanda-data/benthos/v4/internal/cli.Version=${version}"
  ];

  meta = with lib; {
    description = "Fancy stream processing made operationally mundane";
    mainProgram = "benthos";
    homepage = "https://www.benthos.dev";
    changelog = "https://github.com/redpanda-data/benthos/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}

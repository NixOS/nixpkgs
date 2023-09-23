{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "starcharts";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "starcharts";
    rev = "v${version}";
    hash = "sha256-B5w6S3qNLdUayYpF03cnxpLzyRBaC9jhaYnNqDZ2AsU=";
  };

  vendorHash = "sha256-sZS3OA1dTLLrL5csXV6nWbY/TLiqJUH1UQnJUEva7Jk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Plot your repository stars over time";
    homepage = "https://github.com/caarlos0/starcharts";
    changelog = "https://github.com/caarlos0/starcharts/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

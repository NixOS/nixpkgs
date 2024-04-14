{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-pu6U6YIA7+K1ZSt97Nn0IDaQFVIwMq3m7d8JidK1vJk=";
  };

  vendorHash = "sha256-QqhjS0uL2Fm2OeFkuAB8VeS7HpoS9dOhgHk/J4j9++M=";

  ldflags = [
    "-s"
    "-w"
    "-X" "main.BuildVersion=${version}"
    "-X" "main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
}

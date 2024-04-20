{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    rev = "refs/tags/v${version}";
    hash = "sha256-upqsQQlrDRRcLMAe7nI86Sc2y3hNpELEeM5Im4XfLl8=";
  };

  vendorHash = "sha256-OehyKcO8AwQ8D+KeMg9T/0/T9wSuzdkVVfbginlQJro=";

  subPackages = [
    "cmd/katana"
  ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    mainProgram = "katana";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}

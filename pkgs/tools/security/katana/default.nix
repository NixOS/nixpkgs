{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    rev = "refs/tags/v${version}";
    hash = "sha256-phxJhrZaJ+gw7gZWwQK0pvWWxkS4UDi77s+qgTvS/fo=";
  };

  vendorHash = "sha256-go+6NOQOnmds7EuA5k076Qdib2CqGthH9BHOm0YYKaA=";

  subPackages = [
    "cmd/katana"
  ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}

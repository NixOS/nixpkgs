{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LXyYdfBrqtMN4qGakQDG/axzmDTYkwCun2xw9Heaejk=";
  };

  vendorHash = "sha256-MEmVmokQX/HfBPvObeW1M5L6zm2KXB1yzGmNFBjt+i0=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/katana" ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0OXpA+sa97YjbHhIq3Uj65OWg53PH9y2cY8bjCqC3tQ=";
  };

  vendorHash = "sha256-rb0fNAOP4y2yvJb7FIlAIfXF0uw0eLKgup75f9cwT6U=";

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

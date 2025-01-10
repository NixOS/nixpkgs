{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    rev = "refs/tags/v${version}";
    hash = "sha256-aXKDSV/+okwO4UbljQr2fS/UcJkb5gC1nPZgpN7GuLY=";
  };

  vendorHash = "sha256-xRxbLI+CEgMYh3nThUCqcKQR6AQV/J6E98xVTfcD2h4=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    mainProgram = "cloudlist";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

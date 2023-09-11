{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    rev = "refs/tags/${version}";
    hash = "sha256-DY9/qcE8Ryue6NEWglM1F+xd669DPBIgt743ta+O//4=";
  };

  vendorHash = "sha256-dFjyeIiDGdGTlZoZvsW9cwb+urS0NRxBMFf3+Y+rsAE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI utility to find subdomains from curated passive online sources";
    homepage = "https://github.com/hueristiq/xsubfind3r";
    changelog = "https://github.com/hueristiq/xsubfind3r/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

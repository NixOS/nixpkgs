{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    rev = "refs/tags/${version}";
    hash = "sha256-tukynKPcIwDwpH0/SFyif6OGVZrmLVdXfhrFaaVd1d8=";
  };

  vendorHash = "sha256-0tX/s5a6PPQuEw3BTs6uW9c5OHqXryzIfDNPnQH5sS8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI utility to find subdomains from curated passive online sources";
    mainProgram = "xsubfind3r";
    homepage = "https://github.com/hueristiq/xsubfind3r";
    changelog = "https://github.com/hueristiq/xsubfind3r/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

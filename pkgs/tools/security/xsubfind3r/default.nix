{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    rev = "refs/tags/${version}";
    hash = "sha256-Xlxn9IZ9TTDzkEkyBoBwrS9AdQX21mmHngm03w+c4UM=";
  };

  vendorHash = "sha256-DkYQkuhBAYnGx9gxi2X/Coh0FYV+z5/4IX1zTfUM6uI=";

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

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    rev = "refs/tags/v${version}";
    hash = "sha256-F1oiatNP4tSRWI25r1uoiLT9Et+PyqU0p2HVICMBUNA=";
  };

  vendorHash = "sha256-3QS9YYypqEJhibfBFxFq1gxTVpTWBy35tXcO9+DBehY=";

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

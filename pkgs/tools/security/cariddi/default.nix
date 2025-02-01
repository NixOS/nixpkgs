{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    rev = "refs/tags/v${version}";
    hash = "sha256-mRrUTRknax3b4hs3frQMzg0GyB3WjMDZJk0RQSAC88U=";
  };

  vendorHash = "sha256-ML1aLbrYhs2IxnN2ywKFOpvAV6yuYb8GI+dtoxwJl4A=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cariddi";
  };
}

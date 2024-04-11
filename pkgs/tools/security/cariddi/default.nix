{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    rev = "refs/tags/v${version}";
    hash = "sha256-nApgsvHSMWmgJWyvdtBdrGt9v8YSwWiGnmrDS8vVvDw=";
  };

  vendorHash = "sha256-GgJyYDnlaFybf3Gu1gVcA12HkA0yUIjYEFj0G83GVGQ=";

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

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hgz+/DEoCo4lxcFkawQgIc3ct7cc2NwpAnfBtZQruf0=";
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

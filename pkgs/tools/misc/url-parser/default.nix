{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-1KNe2sYr2DtRJGdgqs7JAA788Qa3+Z7iTntCkiJd29I=";
  };

  vendorHash = "sha256-DAwPYihfOorC61/UhRNNOsOaAjbu8mDBaikGJIOzk6Y=";

  ldflags = [
    "-s"
    "-w"
    "-X" "main.BuildVersion=${version}"
    "-X" "main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
}

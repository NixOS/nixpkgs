{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-g4fpyzDgIf/4kBAfNxLst0KKa+vNSCryljFAW1j8wmc=";
  };

  vendorHash = "sha256-HOlX8oHktbgnbPkRf9iUMCUpGlbcQwusMMcHJJl2nOs=";

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

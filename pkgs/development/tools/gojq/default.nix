{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.13";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tlnj0CCsPZRQjIZCvNPjN0JD6oqRDvdWOCYR3tYMPUA=";
  };

  vendorHash = "sha256-DVJZ35C+6SuhaaGDM3u+3fB1497qaW6oTByAUPVwhJI=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    changelog = "https://github.com/itchyny/gojq/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "gojq";
  };
}

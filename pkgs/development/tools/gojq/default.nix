{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.15";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2Og1Ek8Hnzd4KTgJurWtPaqm0W6ruoJ1RN2G+l/5yIY=";
  };

  vendorHash = "sha256-tZB52w15MpAO3UnrDkhmL1M3EIcm/QwrPy9gvJycuD0=";

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

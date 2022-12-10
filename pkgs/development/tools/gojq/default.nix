{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.10";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JlxxfazVNJzQzG2p8L+5MoevSNNWf5mi14n3f/Q+MZU=";
  };

  vendorSha256 = "sha256-BnDtHqqU/kFJyeG1g4UZ51eSnUlbQ6eRKTFoz6kxl0s=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };
}

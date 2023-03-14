{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.12";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-axiIHy6vNs0ySVP4UnYZ9J+GeAOz3LJ9vOP1xT4dcME=";
  };

  vendorHash = "sha256-kHwCh/6yaPaFce5k3NgAQ1GsoVmvmfIJujVaMwqrLBM=";

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
  };
}

{ buildGoModule, fetchFromGitHub, lib, numary, testers }:

buildGoModule rec {
  pname = "numary";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "numary";
    repo = "ledger";
    rev = "v${version}";
    hash = "sha256-fNV5a70Kno+6TozjcGRygxdJmrFepe+s8wIbbzO5q4k=";
  };

  vendorSha256 = "sha256-P4/wq2Sn6xEcIzYUFf6Vus1wrBBGKumTYFRoCEfkvrQ=";

  passthru.tests.version = testers.testVersion {
    package = numary;
    command = "numary version";
  };

  checkPhase = "";

  meta = with lib; {
    description = "A programmable financial ledger to build money-moving apps";
    homepage = "https://www.formance.com/";
    license = licenses.mit;
  };
}

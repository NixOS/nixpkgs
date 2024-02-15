{ lib, fetchFromGitHub, crystal, openssl, testers, amqpcat }:

crystal.buildCrystalPackage rec {
  pname = "amqpcat";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "cloudamqp";
    repo = "amqpcat";
    rev = "v${version}";
    hash = "sha256-AXX4aF5717lSIO0/2jNDPXXLtM/h//BlxO+cX71aWG4=";
  };

  format = "shards";
  shardsFile = ./shards.nix;

  buildInputs = [ openssl ];

  # Tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = amqpcat;
  };

  meta = with lib; {
    description = "A CLI tool for publishing to and consuming from AMQP servers";
    homepage = "https://github.com/cloudamqp/amqpcat";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };
}

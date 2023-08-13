{ stdenv, lib, fetchFromGitHub, crystal, openssl, testers, amqpcat }:

crystal.buildCrystalPackage rec {
  pname = "amqpcat";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "cloudamqp";
    repo = "amqpcat";
    rev = "v${version}";
    hash = "sha256-Ec8LlOYYp3fXYgvps/ikeB4MqBEXTw1BAF5nJyL7dI0=";
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
    broken = stdenv.isDarwin; # Linking errors. Hope someone can help fix it.
  };
}

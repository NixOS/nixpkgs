{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kaf";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    hash = "sha256-12xPBBLV0jtQQI/inNlWTFBZtYBF0GF1GoD1kv1/thQ=";
  };

  vendorHash = "sha256-otKz8ECSb2N3vwU5c1+u7zGvXU4iRvQWWggw9WwG78c=";

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    mainProgram = "kaf";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}

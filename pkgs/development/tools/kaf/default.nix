{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kaf";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    hash = "sha256-H21l8TXCl5UH7h0WXnJqFv/rozIzxBKJJcNzfqIATsQ=";
  };

  vendorHash = "sha256-//16AAQ2NK3yf9BKWECz5Mdy0lYuft9Em5cyM8osans=";

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}

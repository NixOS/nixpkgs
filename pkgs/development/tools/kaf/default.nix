{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kaf";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    hash = "sha256-BH956k2FU855cKT+ftFOtRR2IjQ4sViiGy0tvrMWpEQ=";
  };

  vendorHash = "sha256-Y8jma4M+7ndJARfLmGCUmkIL+Pkey599dRO7M4iXU2Y=";

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}

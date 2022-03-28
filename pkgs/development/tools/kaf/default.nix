{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kaf";
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    sha256 = "sha256-gKg/iESUXS6l3v5ovdvvrfpvaUzahPtqh0/DH5OpXoY=";
  };

  vendorSha256 = "sha256-5WzREsQdcp9lelKUEXw+nHeemHBDsKrvRcG9v+qln/E=";

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kaf";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    sha256 = "sha256-5wSxaryaQ8jXwpzSltMmFRVrvaA9JMSrh8VBCnquLXE=";
  };

  vendorSha256 = "sha256-Jpv02h+EeRhVdi/raStTEfHitz0A71dHpWdF/zcVJVU=";

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}

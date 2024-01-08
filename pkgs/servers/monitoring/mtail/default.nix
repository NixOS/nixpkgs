{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc53";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-bKNSUXBnKDYaF0VyFn1ke6UkdZWHu5JbUkPPRfIdkh8=";
  };

  vendorHash = "sha256-z71Q1I4PG7a1PqBLQV1yHlXImORp8cEtKik9itfvvNs=";

  doCheck = false;

  subPackages = [ "cmd/mtail" ];

  preBuild = ''
    go generate -x ./internal/vm/
  '';

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}

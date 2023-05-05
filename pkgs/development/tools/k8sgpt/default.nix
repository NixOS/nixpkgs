{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "k8sgpt";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${version}";
    hash = "sha256-tS0yoMK1F4QxG0XLFYjs180jyF7qb7JMbYESBD2PPg0=";
  };

  vendorHash = "sha256-nutpoc8UAPXgvBr4hUTYq9/d5OQXGOl3QNtaWhH9Cpw=";

  CGO_ENABLED = 0;
  GO111MODULE = "on";
  GOFLAGS = "-trimpath";

  subPackages = [ "./main.go" ];

  ldflags = [
    "-s"
    "-w"
    "-buildid="
    "-X main.version={{.Version}}=${version}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/k8sgpt-ai/k8sgpt";
    changelog = "https://github.com/k8sgpt-ai/k8sgpt/releases/tag/v${version}";
    description = "Giving Kubernetes Superpowers to everyone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy ];
  };
}

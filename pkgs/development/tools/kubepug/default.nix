{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    sha256 = "sha256-jQ/LzwxYxfCKiu+2VhjQ3YWwLEqZkYrH7+olBOMUA1A=";
  };

  vendorSha256 = "sha256-P5HoU9AAGFrSrp9iymjW+r8w5L90KUOrmaXM8p+Wn44=";

  ldflags = [
    "-s" "-w" "-X=github.com/rikatz/kubepug/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/kubepug.go" ];

  meta = with lib; {
    description = "Checks a Kubernetes cluster for objects using deprecated API versions";
    homepage = "https://github.com/rikatz/kubepug";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D/1psEpOoDiA/dpnUc9sUaOq8Dk5QEImIWEp08FyV7o=";
  };

  vendorSha256 = "sha256-guJgLjmB29sOLIzs2+gKNp0WTWC3zS9Sb5DD5IistKY=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = with maintainers; [ marsam techknowlogick ];
    license = with licenses; [ mit ];
  };
}

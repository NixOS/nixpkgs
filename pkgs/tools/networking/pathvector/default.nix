{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pathvector";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "pathvector";
    rev = "v${version}";
    sha256 = "sha256-5A5THSBVOAX+VsBbht7HobiHFEdv6dohUwCeegAijYE=";
  };

  vendorHash = "sha256-2G+RqG2i6APvpbOltQeP/Kt7d/LAwbecaYHOFrdnCQo=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" "-X main.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "Declarative edge routing platform that automates route optimization and control plane configuration";
    homepage = "https://pathvector.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthewpi ];
  };
}

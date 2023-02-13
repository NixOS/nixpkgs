{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pathvector";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "pathvector";
    rev = "v${version}";
    sha256 = "sha256-tMcoL+nvvMBCWSVD+l42e6IlOIj8ERP9pgBHcJBtegY=";
  };

  vendorHash = "sha256-+GML6a9LzHZfByHv7ODp7fHBauExsZTzUccMEeeOFNg=";

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

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pathvector";
  version = "5.11.1";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "pathvector";
    rev = "v${version}";
    sha256 = "sha256-OgIDk+05bG2KrBQOyyMPaH0OJXU3gLM9OBab9lI+yXw=";
  };

  vendorSha256 = "sha256-R3o1L34FXbtRzJ1I2Xj4iWsiFJJWexGWYv2TmvhINe0=";

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

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pathvector";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "pathvector";
    rev = "v${version}";
    sha256 = "sha256-RdUZkkALEdyq+YKtgGE/P8eTX2v3fdYHF1wpZEyfkgY=";
  };

  vendorSha256 = "sha256-oxLMfmHLaOQwpRYwnHRQY0mIV5/fZ65RDgKVs0Kzd2Q=";

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

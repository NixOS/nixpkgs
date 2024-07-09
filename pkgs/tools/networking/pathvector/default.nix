{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pathvector";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "pathvector";
    rev = "v${version}";
    sha256 = "sha256-TqGasguEAcA5ET2E/uFjgIl7IHI2v9m5EaXpIMG3T8c=";
  };

  vendorHash = "sha256-hgUuntT6jMWI14qDE3Yjm5W8UqQ6CcvoILmSDaVEZac=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" "-X main.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "Declarative edge routing platform that automates route optimization and control plane configuration";
    homepage = "https://pathvector.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthewpi ];
    mainProgram = "pathvector";
  };
}

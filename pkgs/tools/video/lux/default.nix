{ lib, buildGoModule, fetchFromGitHub, makeWrapper, ffmpeg }:

buildGoModule rec {
  pname = "lux";
  version = "0.17.2";
  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
    sha256 = "sha256-bEfDZkbASGQcx6IT5m1oy42maEJp8ElMC4uvjPwJbDU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-7WgTRnt1RsoMattIiYH2GFlQF12zoWTRkm3vts07/ho=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    wrapProgram $out/bin/lux \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  doCheck = false;

  meta = with lib; {
    description = "Fast and simple video download library and CLI tool written in Go";
    homepage = "https://github.com/iawia002/lux";
    changelog = "https://github.com/iawia002/lux/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [];
  };
}

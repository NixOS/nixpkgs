{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, ffmpeg
}:

buildGoModule rec {
  pname = "lux";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
    hash = "sha256-LCYWfF7O8wByCJNDi2BZsI7EU6wJqhcr/sbNOoQ2Src=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-wW/jrsurmyLcDX+58lp0M+snJ2avEs0HciNZ8BgIqrI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/iawia002/lux/app.version=v${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/lux \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  doCheck = false; # require network

  meta = with lib; {
    description = "Fast and simple video download library and CLI tool written in Go";
    homepage = "https://github.com/iawia002/lux";
    changelog = "https://github.com/iawia002/lux/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ galaxy ];
    mainProgram = "lux";
  };
}

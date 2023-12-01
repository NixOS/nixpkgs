{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, ffmpeg
}:

buildGoModule rec {
  pname = "lux";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
    hash = "sha256-v74+Ykz9aro1x+9psg2LnuodKE2/pCw9knZop0etQOg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-1VZFKDoSuSUmYw7g6SwB/dXnFaw7+cGHKfgT96HaI/o=";

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

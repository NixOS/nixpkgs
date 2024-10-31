{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, ffmpeg
}:

buildGoModule rec {
  pname = "lux";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
    hash = "sha256-3d8EQ7GzufZvMfjHbVMdpuGE+vPdSir4diSnB29v0sw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-RCZzcycUKqJgwBZZQBD1UEZCZCitpiqNpD51oKm6IvI=";

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

{ lib, buildGoModule, fetchFromGitHub, makeBinaryWrapper, ffmpeg-headless }:

buildGoModule rec {
  pname = "ytarchive";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "v${version}";
    hash = "sha256-mQgpwuTIEHeDv/PzBHpK1sraxFj8Ef3y8vN5bLw5E94=";
  };

  vendorHash = "sha256-sjwQ/zEYJRkeWUDB7TzV8z+kET8lVRnQkXYbZbcUeHY=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [ "-s" "-w" "-X main.Commit=-${src.rev}" ];

  postInstall = ''
    wrapProgram $out/bin/ytarchive --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/Kethsar/ytarchive";
    description = "Garbage Youtube livestream downloader";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ytarchive";
  };
}

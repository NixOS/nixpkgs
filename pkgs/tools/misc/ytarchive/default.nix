{ lib, buildGoModule, fetchFromGitHub, fetchpatch, makeBinaryWrapper, ffmpeg }:

buildGoModule rec {
  pname = "ytarchive";
  version = "unstable-2023-02-21";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "90aaf17b5e86eec52a95752e3c2dba4f54ee1068";
    hash = "sha256-JRjQRbMqtd04/aO6NkInoDqfOrHnDrXj4C4/URiU6yo=";
  };

  vendorHash = "sha256-sjwQ/zEYJRkeWUDB7TzV8z+kET8lVRnQkXYbZbcUeHY=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [ "-s" "-w" "-X main.Commit=-${src.rev}" ];

  postInstall = ''
    wrapProgram $out/bin/ytarchive --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/Kethsar/ytarchive";
    description = "Garbage Youtube livestream downloader";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}

{ lib, buildGoModule, fetchFromGitHub, makeWrapper, ffmpeg }:

buildGoModule rec {
  pname = "ytarchive";
  version = "unstable-2022-03-11";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "34825e8777637ca114a0ab394a4b4fead6ad7c88";
    sha256 = "sha256-/x6YcF2EyjOFnIHlsh+ZESF+7AYO3QRNaqbJgycQai4=";
  };

  vendorSha256 = "sha256-r9fDFSCDItQ7YSj9aTY1LXRrFE9T3XD0X36ywCfu0R8=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" "-w" ];

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

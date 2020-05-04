{ buildGoModule, fetchFromGitHub, lib, wl-clipboard, makeWrapper }:

buildGoModule rec {
  pname = "clipman";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "yory8";
    repo = pname;
    rev = "v${version}";
    sha256 = "15s7np57pvh7mqmq016mvhz34f189wd1vrfiamzmps37mdz2nq9i";
  };

  modSha256 = "1sim3x794kj3wdw0g432zbgh1cimdmmg1hjgynh9jgm3y8w9q7ij";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clipman \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/yory8/clipman";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
    description = "A simple clipboard manager for Wayland";
    platforms = platforms.linux;
  };
}

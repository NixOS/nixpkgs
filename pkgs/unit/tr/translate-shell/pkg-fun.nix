{ lib, stdenv, fetchFromGitHub, makeWrapper, curl, fribidi, rlwrap, gawk, groff, ncurses, hexdump }:

stdenv.mkDerivation rec {
  pname = "translate-shell";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = "translate-shell";
    rev = "v${version}";
    sha256 = "sha256-OLbGBP+QHW51mt0sFXf6SqrIYZ0iC/X10F148NAG4A4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/trans \
      --prefix PATH : ${lib.makeBinPath [
        gawk
        curl
        ncurses
        rlwrap
        groff
        fribidi
        hexdump
      ]}
  '';

  meta = with lib; {
    homepage = "https://www.soimort.org/translate-shell";
    description = "Command-line translator using Google Translate, Bing Translator, Yandex.Translate, and Apertium";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ebzzry infinisil ];
    mainProgram = "trans";
    platforms = platforms.unix;
  };
}

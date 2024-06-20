{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "epub2txt2";
  version = "2.07";

  src = fetchFromGitHub {
    owner = "kevinboone";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-/P81ZXhB0wyRx2bb/CO7+kTTNspYKoGUpBGLb8Yfb5I=";
  };

  makeFlags = [ "CC:=$(CC)" "PREFIX:=$(out)" ];

  meta = {
    description = "Simple command-line utility for Linux, for extracting text from EPUB documents";
    homepage = "https://github.com/kevinboone/epub2txt2";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.leonid ];
    mainProgram = "epub2txt";
  };
}

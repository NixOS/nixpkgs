{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "epub2txt2";
  version = "2.06";

  src = fetchFromGitHub {
    owner = "kevinboone";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zzcig5XNh9TqUHginsfoC47WrKavqi6k6ezir+OOMJk=";
  };

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX:=$(out)"
  ];

  meta = {
    description = "A simple command-line utility for Linux, for extracting text from EPUB documents";
    homepage = "https://github.com/kevinboone/epub2txt2";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.leonid ];
    mainProgram = "epub2txt";
  };
}

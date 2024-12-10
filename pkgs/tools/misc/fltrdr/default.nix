{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  icu,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "fltrdr";
  version = "0.3.1";

  src = fetchFromGitHub {
    repo = "fltrdr";
    owner = "octobanana";
    rev = version;
    sha256 = "1vpci7vqzcpdd21zgigyz38k77r9fc81dmiwsvfr8w7gad5sg6sj";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    icu
    openssl
  ];

  meta = with lib; {
    homepage = "https://octobanana.com/software/fltrdr";
    description = "A TUI text reader for the terminal";

    longDescription = ''
      Fltrdr, or flat-reader, is an interactive text reader for the terminal. It
      is flat in the sense that the reader is word-based. It creates a
      horizontal stream of words, ignoring all newline characters and reducing
      extra whitespace. Its purpose is to facilitate reading, scanning, and
      searching text. The program has a play mode that moves the reader forward
      one word at a time, along with a configurable words per minute (WPM),
      setting.
    '';

    platforms = platforms.linux; # can only test linux
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    mainProgram = "fltrdr";
  };
}

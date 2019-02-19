{ stdenv
, fetchFromGitHub
, gcc8
, cmake
}:

stdenv.mkDerivation rec {
  name = "fltrdr-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    repo   = "fltrdr";
    owner  = "octobanana";
    rev    = "${version}";
    sha256 = "1qnlbw3r82hdppxprah933ycw6lddv54mb1jl6df0ikvxgqrjw3q";
  };

  buildInputs = [ gcc8 cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://octobanana.com/software/fltrdr;
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

    platforms   = platforms.linux; # can only test linux
    license     = licenses.mit;
    maintainers = [ stdenv.maintainers.matthiasbeyer ];
  };
}


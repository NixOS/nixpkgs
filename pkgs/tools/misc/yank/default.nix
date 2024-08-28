{ lib, stdenv, fetchFromGitHub, xsel }:

stdenv.mkDerivation rec {
  pname = "yank";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mptre";
    repo = "yank";
    rev = "v${version}";
    sha256 = "sha256-sZiZki2Zl0Tfmls5KrLGxT94Bdf9TA9EwoaLoFOX9B4=";
  };

  installFlags = [ "PREFIX=$(out)" ];
  makeFlags = [ "YANKCMD=${xsel}/bin/xsel" ];

  meta = with lib; {
    homepage = "https://github.com/mptre/yank";
    description = "Yank terminal output to clipboard";
    longDescription = ''
      Read input from stdin and display a selection interface that allows a
      field to be selected and copied to the clipboard. Fields are determined
      by splitting the input on a delimiter sequence, optionally specified
      using the -d option. New line, carriage return and tab characters are
      always treated as delimiters.
    '';
    downloadPage = "https://github.com/mptre/yank/releases";
    license = licenses.mit;
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
    mainProgram = "yank";
  };

}

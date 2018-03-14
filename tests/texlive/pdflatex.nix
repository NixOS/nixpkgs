{ substituteAll, texlive, poppler_utils, runCommand, lib, text ? "Just a test string" }:
runCommand "test-pdflatex" {
  buildInputs = [
    (texlive.combine {inherit (texlive) scheme-small; }) poppler_utils
  ];
  inherit text;
  passthru = {
    inherit text;
  };
} ''
  substituteAll ${./pdflatex.tex} text.tex
  pdflatex text.tex
  mkdir -p "$out"
  cp text.pdf "$out/"
  pdftotext "$out/text.pdf" "$out/text-check.txt"
  grep -F ${lib.escapeShellArg text} "$out/text-check.txt"
''

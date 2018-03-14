{ substituteAll, texlive, poppler_utils, imagemagick, tesseract, ghostscript, withFonts, runCommand, lib, text ? "Just a test string" }:
runCommand "test-xelatex" {
  buildInputs = [
    (texlive.combine {inherit (texlive) scheme-small; })
    (withFonts [])
    poppler_utils imagemagick tesseract ghostscript
  ];
  inherit text;
  passthru = {
    inherit text;
  };
} ''
  substituteAll ${./xelatex.tex} text.tex
  xelatex text.tex
  mkdir -p "$out"
  cp text.pdf "$out/"
  pdftotext "$out/text.pdf" "$out/text-check.txt"
  grep -F ${lib.escapeShellArg text} "$out/text-check.txt"

  convert -density 300 "$out/text.pdf" "$out/text-check.png"
  tesseract -l eng "$out/text-check.png" stdout | grep -F ${lib.escapeShellArg text}
''

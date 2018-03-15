{ substituteAll, texlive, poppler_utils, runCommand, lib
, text ? "Just a test string", texCommand }:
runCommand "test-${texCommand}" {
  buildInputs = [
    (texlive.combine {inherit (texlive) scheme-small; }) poppler_utils
    (import ../temporary-helpers/with-fonts.nix {})
  ];
  inherit text;
  passthru = {
    inherit text;
  };
} ''
  substituteAll "${./.}/${texCommand}.tex" text.tex
  ${texCommand} text.tex
  mkdir -p "$out"
  cp text.pdf "$out/"
  pdftotext "$out/text.pdf" "$out/text-check.txt"
  grep -F ${lib.escapeShellArg text} "$out/text-check.txt"
''

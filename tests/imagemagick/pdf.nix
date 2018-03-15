{ imagemagick, runCommand, text ? "Just a test string", lib, tesseract, ghostscript }:
runCommand "imagemagick-pdf-test" {
  buildInputs = [ imagemagick tesseract ghostscript
    (import ../temporary-helpers/with-fonts.nix {})
    ];
  passthru = {
    inherit text;
  };
} ''
  set -x
  mkdir -p "$out"
  convert -font 'DejaVu-Sans' -size 600x -pointsize 32 'caption:  '${lib.escapeShellArg text} "$out/text.pdf"
  convert "$out/text.pdf" "$out/text-check.png"
  tesseract -l eng "$out/text-check.png" stdout | grep -F ${lib.escapeShellArg text}
''

{ runCommand, withRatpoison, withDBus, withHome, fmbtRun, zathura, texlive }:
runCommand "test-latex-zathura" {
  buildInputs = [
    (withRatpoison {}) withDBus withHome
    zathura
    (texlive.combine { inherit (texlive) scheme-small; })
  ]; 
} ''
  cp "${./data/latex-file.tex}" latex-file.tex
  pdflatex latex-file.tex
  zathura ./latex-file.pdf &
  while ! ratpoison -c windows | grep -i latex-file; do sleep 1; done
  ${fmbtRun ''
    screen.type("200=999999k999999h")
    assert(screen.waitOcrText("Test LaTeX content",match=1,
      area=[0.0,0.0,1.0,1.0]))
  ''}

  mkdir -p "$out"/share/
  cp -r screenshots "$out/share"
  exit 0
''

source $stdenv/setup

phases="installPhase"
dontMakeInstall="yes"
prefix="$out"

preInstall() {

  ensureDir "$out/share/texmf-nix/tex/latex/polytable"
  ensureDir "$out/share/texmf-nix/doc/latex/polytable"
  latex polytable.ins
  pdflatex polytable.dtx
  pdflatex polytable.dtx
  cp polytable.sty "$out/share/texmf-nix/tex/latex/polytable"
  cp polytable.pdf "$out/share/texmf-nix/doc/latex/polytable"

}

preInstall=preInstall

genericBuild

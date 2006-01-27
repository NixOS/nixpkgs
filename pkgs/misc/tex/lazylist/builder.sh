source $stdenv/setup

phases="installPhase"
dontMakeInstall="yes"
prefix="$out"

preInstall() {

  ensureDir "$out/share/texmf-nix/tex/latex/lazylist"
  cp lazylist.sty "$out/share/texmf-nix/tex/latex/lazylist"

}

preInstall=preInstall

genericBuild



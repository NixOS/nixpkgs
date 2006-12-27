source $stdenv/setup

buildPhase=true

installPhase=myInstallPhase
myInstallPhase() {
  ensureDir "$out/share/texmf-nix/tex/latex/lazylist"
  cp lazylist.sty "$out/share/texmf-nix/tex/latex/lazylist"
}

genericBuild



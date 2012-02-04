source $stdenv/setup

buildPhase=true

installPhase=myInstallPhase
myInstallPhase() {
  ensureDir "$out/share/texmf-nix/tex/latex/polytable"
  ensureDir "$out/share/texmf-nix/doc/latex/polytable"
  latex polytable.ins
  pdflatex polytable.dtx
  pdflatex polytable.dtx
  cp polytable.sty "$out/share/texmf-nix/tex/latex/polytable"
  cp polytable.pdf "$out/share/texmf-nix/doc/latex/polytable"
  ensureDir "$out/nix-support"
  echo "$propagatedUserEnvPackages" > "$out/nix-support/propagated-user-env-packages"
}

genericBuild

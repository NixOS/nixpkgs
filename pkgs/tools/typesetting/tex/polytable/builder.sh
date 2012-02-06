source $stdenv/setup

buildPhase=true

installPhase=myInstallPhase
myInstallPhase() {
  mkdir -p "$out/share/texmf-nix/tex/latex/polytable"
  mkdir -p "$out/share/texmf-nix/doc/latex/polytable"
  latex polytable.ins
  pdflatex polytable.dtx
  pdflatex polytable.dtx
  cp polytable.sty "$out/share/texmf-nix/tex/latex/polytable"
  cp polytable.pdf "$out/share/texmf-nix/doc/latex/polytable"
  mkdir -p "$out/nix-support"
  echo "$propagatedUserEnvPackages" > "$out/nix-support/propagated-user-env-packages"
}

genericBuild

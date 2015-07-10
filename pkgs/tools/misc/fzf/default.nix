{ stdenv, fetchFromGitHub, goPackages, syncthing, ncurses }:

with goPackages;

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.9.13";
  goPackagePath = "github.com/junegunn/fzf";
  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf";
    rev = "${version}";
    sha256 = "1m9zbf02d6i47c33jys9lr0krqfjk2dr8jzpfhnrb266qcdb27xi";
  };

  buildInputs = with goPackages; [
    crypto
    ginkgo
    gomega
    junegunn.go-runewidth
    go-shellwords
    ncurses
    syncthing
    text
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/fzf;
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
  };
}

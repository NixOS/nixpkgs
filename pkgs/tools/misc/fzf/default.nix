{ stdenv, fetchFromGitHub, goPackages, syncthing, ncurses }:

with goPackages;

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.10.0";
  goPackagePath = "github.com/junegunn/fzf";
  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf";
    rev = "${version}";
    sha256 = "0dx9qwmcrnh31m2n75qmpj1dxm6rr6xsbazy4nwa3bzrb8y6svh2";
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
    maintainers = [ maintainers.magnetophon ];
  };
}

{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gocode-unstable";
  version = "2020-04-06";
  rev = "4acdcbdea79de6b3dee1c637eca5cbea0fdbe37c";

  goPackagePath = "github.com/mdempsky/gocode";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchFromGitHub {
    inherit rev;

    owner = "mdempsky";
    repo = "gocode";
    sha256 = "0i1hc089gb6a4mcgg56vn5l0q96wrlza2n08l4349s3dc2j559fb";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "An autocompletion daemon for the Go programming language";
    longDescription = ''
      Gocode is a helper tool which is intended to be integrated with your
      source code editor, like vim, neovim and emacs. It provides several
      advanced capabilities, which currently includes:

        - Context-sensitive autocompletion

      It is called daemon, because it uses client/server architecture for
      caching purposes. In particular, it makes autocompletions very fast.
      Typical autocompletion time with warm cache is 30ms, which is barely
      noticeable.
    '';
    homepage = "https://github.com/mdempsky/gocode";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}

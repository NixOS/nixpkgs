{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gocode-unstable";
  version = "2018-11-05";
  rev = "0af7a86943a6e0237c90f8aeb74a882e1862c898";

  goPackagePath = "github.com/mdempsky/gocode";
  excludedPackages = ''internal/suggest/testdata'';

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchFromGitHub {
    inherit rev;

    owner = "mdempsky";
    repo = "gocode";
    sha256 = "0fxqn0v6dbwarn444lc1xrx5vfkcidi73f4ba7l4clsb9qdqgyam";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
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
    homepage = https://github.com/mdempsky/gocode;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ kalbasit ];
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gocode-${version}";
  version = "20180727-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "00e7f5ac290aeb20a3d8d31e737ae560a191a1d5";

  goPackagePath = "github.com/mdempsky/gocode";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "gocode";
    inherit rev;
    sha256 = "0vrwjq4r90za47hm88yx5h2mvkv7y4yaj2xbx3skg62wq2drsq31";
  };

  preBuild = ''
    # getting an error building the testdata because they contain invalid files
    # on purpose as part of the testing.
    rm -r go/src/$goPackagePath/internal/suggest/testdata
  '';

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

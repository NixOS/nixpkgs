{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gocode-unstable-${version}";
  version = "2018-10-22";
  rev = "e893215113e5f7594faa3a8eb176c2700c921276";

  goPackagePath = "github.com/mdempsky/gocode";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchFromGitHub {
    inherit rev;

    owner = "mdempsky";
    repo = "gocode";
    sha256 = "1zsll7yghv64890k7skl0g2lg9rsaiisgrfnb8kshsxrcxi1kc2l";
  };

  goDeps = ./deps.nix;

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

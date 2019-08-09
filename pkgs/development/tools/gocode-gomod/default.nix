{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gocode-gomod-unstable-${version}";
  version = "2019-03-27";
  rev = "81059208699789f992bb4a4a3fedd734e335468d";

  goPackagePath = "github.com/stamblerre/gocode";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  excludedPackages = ''internal/suggest/testdata'';

  src = fetchFromGitHub {
    inherit rev;

    owner = "stamblerre";
    repo = "gocode";
    sha256 = "0y5lc7sq3913mvvczwx8mq5l3l9yg34jzaw742q8jpd1jzqyza94";
  };

  goDeps = ./deps.nix;

  postInstall = ''
    mv $bin/bin/gocode $bin/bin/gocode-gomod
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
    homepage = https://github.com/stamblerre/gocode;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ kalbasit rvolosatovs ];
  };
}

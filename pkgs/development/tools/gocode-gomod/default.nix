{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gocode-gomod";
  version = "1.0.0";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchFromGitHub {
    owner = "stamblerre";
    repo = "gocode";
    rev = "v${version}";
    sha256 = "YAOYrPPKgnjCErq8+iW0Le51clGBv0MJy2Nnn7UVo/s=";
  };

  vendorHash = null;

  postInstall = ''
    mv $out/bin/gocode $out/bin/gocode-gomod
  '';

  doCheck = false; # fails on go 1.17

  meta = with lib; {
    description = "An autocompletion daemon for the Go programming language";
    mainProgram = "gocode-gomod";
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
    homepage = "https://github.com/stamblerre/gocode";
    license = licenses.mit;
    maintainers = with maintainers; [
      kalbasit
      rvolosatovs
    ];
  };
}

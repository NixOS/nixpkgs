{ stdenv, buildGoPackage, fetchFromGitHub, git, gnupg, xclip, makeWrapper }:

buildGoPackage rec {
  version = "1.7.1";
  name = "gopass-${version}";

  goPackagePath = "github.com/justwatchcom/gopass";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = "gopass";
    rev = "v${version}";
    sha256 = "01cif6a2xa3c8nki0pas9mywdxs8d9niv8z13mii5hcfqvm0s7aw";
  };

  wrapperPath = with stdenv.lib; makeBinPath ([
    git
    gnupg
    xclip
  ]);

  postInstall = ''
    mkdir -p \
      $bin/share/bash-completion/completions \
      $bin/share/zsh/site-functions \
      $bin/share/fish/vendor_completions.d
    $bin/bin/gopass completion bash > $bin/share/bash-completion/completions/_gopass
    $bin/bin/gopass completion zsh  > $bin/share/zsh/site-functions/_gopass
    $bin/bin/gopass completion fish > $bin/share/fish/vendor_completions.d/gopass.fish
  '';

  postFixup = ''
    wrapProgram $bin/bin/gopass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = with stdenv.lib; {
    description     = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go.";
    homepage        = https://www.justwatch.com/gopass/;
    license         = licenses.mit;
    maintainers     = with maintainers; [ andir ];
    platforms       = platforms.unix;

    longDescription = ''
      gopass is a rewrite of the pass password manager in Go with the aim of
      making it cross-platform and adding additional features. Our target
      audience are professional developers and sysadmins (and especially teams
      of those) who are well versed with a command line interface. One explicit
      goal for this project is to make it more approachable to non-technical
      users. We go by the UNIX philosophy and try to do one thing and do it
      well, providing a stellar user experience and a sane, simple interface.
    '';
  };
}

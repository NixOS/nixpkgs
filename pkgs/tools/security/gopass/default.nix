{ stdenv, buildGoPackage, fetchFromGitHub, git, gnupg, xclip, makeWrapper }:

buildGoPackage rec {
  version = "1.8.4";
  name = "gopass-${version}";

  goPackagePath = "github.com/gopasspw/gopass";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass";
    rev = "v${version}";
    sha256 = "1gw16k09vwarh5qz118s7w2j090phdrrgd2h1q52pv93jpi3br7n";
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
    homepage        = https://www.gopass.pw/;
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

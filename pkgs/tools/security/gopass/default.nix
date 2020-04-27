{ stdenv, buildGoPackage, fetchFromGitHub, git, gnupg, xclip, wl-clipboard, installShellFiles, makeWrapper }:

buildGoPackage rec {
  pname = "gopass";
  version = "1.8.6";

  goPackagePath = "github.com/gopasspw/gopass";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v3sx9hb03bdn4rvsv2r0jzif6p1rx47hrkpsbnwva31k396mck2";
  };

  wrapperPath = stdenv.lib.makeBinPath ([
    git
    gnupg
    xclip
  ] ++ stdenv.lib.optional stdenv.isLinux wl-clipboard);

  postInstall = ''
    for shell in bash fish zsh; do
      $bin/bin/gopass completion $shell > gopass.$shell
      installShellCompletion gopass.$shell
    done
  '';

  postFixup = ''
    wrapProgram $bin/bin/gopass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = with stdenv.lib; {
    description     = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go.";
    homepage        = "https://www.gopass.pw/";
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

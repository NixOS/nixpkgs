{ stdenv, buildGoModule, fetchFromGitHub, git, gnupg, xclip, wl-clipboard, installShellFiles, makeWrapper }:

buildGoModule rec {
  pname = "gopass";
  version = "1.9.0";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cssiglhxnrk1wl8phqkhmljqig5ms5a23sdzf8lywk5f6w2gayh";
  };

  modSha256 = "01p3zv6dq1l68in1qqvlsh7i3ydhhanf54dyf7288x35js8wnmqa";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev}" ];

  wrapperPath = stdenv.lib.makeBinPath ([
    git
    gnupg
    xclip
  ] ++ stdenv.lib.optional stdenv.isLinux wl-clipboard);

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/gopass completion $shell > gopass.$shell
      installShellCompletion gopass.$shell
    done
  '';

  postFixup = ''
    wrapProgram $out/bin/gopass \
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

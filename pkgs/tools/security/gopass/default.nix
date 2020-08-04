{ stdenv, makeWrapper
, buildGoModule, fetchFromGitHub, installShellFiles
, git
, gnupg
, xclip
, wl-clipboard
, passAlias ? false
}:

buildGoModule rec {
  pname = "gopass";
  version = "1.9.2";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    sha256 = "066dphw8xq0g72kj64sdai2yyllnr6ca27bfy5sxhk8x69j97rvz";
  };

  vendorSha256 = "1wn20bh7ma4pblsf6qnlbz5bx4p9apig3d1yz7cpsqv4z3w07baw";

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
  '' + stdenv.lib.optionalString passAlias ''
    ln -s $out/bin/gopass $out/bin/pass
  '';

  postFixup = ''
    wrapProgram $out/bin/gopass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = with stdenv.lib; {
    description     = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go.";
    homepage        = "https://www.gopass.pw/";
    license         = licenses.mit;
    maintainers     = with maintainers; [ andir rvolosatovs ];
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

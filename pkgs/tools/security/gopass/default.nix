{ lib
, stdenv
, makeWrapper
, buildGoModule
, fetchFromGitHub
, installShellFiles
, git
, gnupg
, xclip
, wl-clipboard
, passAlias ? false
}:

buildGoModule rec {
  pname = "gopass";
  version = "1.12.4";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cwmka6shyycp9gq5js1hnbamdhqzpmzraxdaniz1cdqhxcvdkcb";
  };

  vendorSha256 = "1qnxdrqpav6ky6gs9w63l0hbhakh23rrc9197br1nmbg0slb8vcj";

  subPackages = [ "." ];

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev}" ];

  wrapperPath = lib.makeBinPath (
    [
      git
      gnupg
      xclip
    ] ++ lib.optional stdenv.isLinux wl-clipboard
  );

  postInstall = ''
    HOME=$TMPDIR
    for shell in bash fish zsh; do
      $out/bin/gopass completion $shell > gopass.$shell
      installShellCompletion gopass.$shell
    done
    go run helpers/man/main.go > gopass.1
    installManPage gopass.1
  '' + lib.optionalString passAlias ''
    ln -s $out/bin/gopass $out/bin/pass
  '';

  postFixup = ''
    wrapProgram $out/bin/gopass --prefix PATH : "${wrapperPath}"
  '';

  meta = with lib; {
    description = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go";
    homepage = "https://www.gopass.pw/";
    license = licenses.mit;
    maintainers = with maintainers; [ andir rvolosatovs ];
    changelog = "https://github.com/gopasspw/gopass/blob/v${version}/CHANGELOG.md";

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

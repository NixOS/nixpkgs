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
  version = "1.12.8";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f3nnhipx2p8w04rxva0pcf7g1nhr4f5bz5dbvr2m76lkiaz5q3v";
  };

  vendorSha256 = "14khs15k9d5m5dms3l4a5bi0s3zl1irm0i4s9pf86gpyz7b55l6a";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" ];

  wrapperPath = lib.makeBinPath (
    [
      git
      gnupg
      xclip
    ] ++ lib.optional stdenv.isLinux wl-clipboard
  );

  postInstall = ''
    installManPage gopass.1
    installShellCompletion --zsh --name _gopass zsh.completion
    installShellCompletion --bash --name gopass.bash bash.completion
    installShellCompletion --fish --name gopass.fish fish.completion
  '' + lib.optionalString passAlias ''
    ln -s $out/bin/gopass $out/bin/pass
  '';

  postFixup = ''
    wrapProgram $out/bin/gopass \
      --prefix PATH : "${wrapperPath}" \
      --set GOPASS_NO_REMINDER true
  '';

  meta = with lib; {
    description = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go";
    homepage = "https://www.gopass.pw/";
    license = licenses.mit;
    maintainers = with maintainers; [ andir rvolosatovs ];
    changelog = "https://github.com/gopasspw/gopass/raw/v${version}/CHANGELOG.md";

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

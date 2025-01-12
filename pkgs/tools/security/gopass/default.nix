{
  lib,
  stdenv,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  gnupg,
  xclip,
  wl-clipboard,
  passAlias ? false,
  apple-sdk_14,
  testers,
  nix-update-script,
  gopass,
}:

buildGoModule rec {
  pname = "gopass";
  version = "1.15.15";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # For ScreenCaptureKit.h, see https://github.com/NixOS/nixpkgs/pull/358760#discussion_r1858327365
    apple-sdk_14
  ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass";
    rev = "v${version}";
    hash = "sha256-GL0vnrNz9vcdybubYIjiK0tDH3L4lNWNo+rAAWv7d8o=";
  };

  vendorHash = "sha256-dDy7eQe/JtAsB+cPONiqUwcCsbisCLzY/5YQaH9w2Yg=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  wrapperPath = lib.makeBinPath (
    [
      git
      gnupg
      xclip
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux wl-clipboard
  );

  postInstall =
    ''
      installManPage gopass.1
      installShellCompletion --cmd gopass \
        --zsh zsh.completion \
        --bash bash.completion \
        --fish fish.completion
    ''
    + lib.optionalString passAlias ''
      ln -s $out/bin/gopass $out/bin/pass
    '';

  postFixup = ''
    wrapProgram $out/bin/gopass \
      --prefix PATH : "${wrapperPath}" \
      --set GOPASS_NO_REMINDER true
  '';
  passthru = {
    inherit wrapperPath;

    tests.version = testers.testVersion {
      package = gopass;
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Slightly more awesome Standard Unix Password Manager for Teams. Written in Go";
    homepage = "https://www.gopass.pw/";
    license = licenses.mit;
    maintainers = with maintainers; [
      rvolosatovs
      sikmir
    ];
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
    mainProgram = "gopass";
  };
}

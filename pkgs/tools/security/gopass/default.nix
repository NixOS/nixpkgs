{
  lib,
  stdenv,
  makeBinaryWrapper,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
  gnupg,
  xclip,
  wl-clipboard,
  passAlias ? false,
  apple-sdk_14,
  nix-update-script,
  versionCheckHook,
}:

let
  wrapperPath = lib.makeBinPath (
    [
      gitMinimal
      gnupg
      xclip
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wl-clipboard
    ]
  );
in
buildGoModule (finalAttrs: {
  pname = "gopass";
  version = "1.15.18";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # For ScreenCaptureKit.h, see https://github.com/NixOS/nixpkgs/pull/358760#discussion_r1858327365
    apple-sdk_14
  ];

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0vAZfcI/cUS/+x9clX9dV1q9yPOP3ZYPrn7hLPaYy/U=";
  };

  vendorHash = "sha256-HH0VU/JdRbpLK4pp2WOewXmv7Slu35iC2tFZ1TYWn5s=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postInstall = ''
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    inherit wrapperPath;

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Slightly more awesome Standard Unix Password Manager for Teams. Written in Go";
    homepage = "https://www.gopass.pw/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rvolosatovs
      sikmir
    ];
    changelog = "https://github.com/gopasspw/gopass/blob/v${finalAttrs.version}/CHANGELOG.md";

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
})

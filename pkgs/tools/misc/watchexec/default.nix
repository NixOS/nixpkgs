{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Cocoa,
  AppKit,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wm3zse5VqUNZ5d6ksCXXrngCcwrAniQbQqx9MOJoK58=";
  };

  cargoHash = "sha256-92lvMka6IqzNAxvYSMUeiDfYw4uKZjjpkZOABq9Mypo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
    AppKit
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  checkFlags = [
    "--skip=help"
    "--skip=help_short"
  ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    mainProgram = "watchexec";
  };
}

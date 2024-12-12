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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kbcSm1plh5QS87hGQj9OL1rq2eK6jbGn/kfjPF6kNzo=";
  };

  cargoHash = "sha256-xLUI7B7clpdJQOMDd32ag87yQ99XgbLgPqahPwUHMZQ=";

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

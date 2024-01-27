{ lib, stdenv, rustPlatform, fetchFromGitHub, Cocoa, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0zBY0PS7qJCAabg9ZKX1JC+gaTM/WSs2U6Avcq3MHmQ=";
  };

  cargoHash = "sha256-RSJOGiSziI2OJkRJAxPZ57uyPPjd3uExijHdIy52dr4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa AppKit ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework AppKit";

  checkFlags = [ "--skip=help" "--skip=help_short" ];

  postPatch = ''
    rm .cargo/config
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

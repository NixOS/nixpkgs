{ lib, stdenv, rustPlatform, fetchFromGitHub, Cocoa, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dO1vIzjsBrrMQ0H3Yv4X5rYPlCrWSlPbFmyooaODPeo=";
  };

  cargoHash = "sha256-6bLY9m6g7hSlYI3KrLS3fN4ATRkkbtq3Wf5xqS1G30s=";

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
  };
}

{ lib, stdenv, rustPlatform, fetchFromGitHub, Cocoa, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.20.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "cli-v${version}";
    sha256 = "sha256-x1weerTOpD4g1Fbm5erbS4S87ZjygF2X3MyyXl+9DXw=";
  };

  cargoSha256 = "sha256-hyPIdMVUXc03B8opcqq7y0wS1rqCfOQ1W5M8jDUqr0k=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa AppKit ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework AppKit";

  checkFlags = [ "--skip=help" "--skip=help_short" ];

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

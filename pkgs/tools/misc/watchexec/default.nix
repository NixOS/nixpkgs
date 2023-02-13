{ lib, stdenv, rustPlatform, fetchFromGitHub, Cocoa, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.20.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "cli-v${version}";
    sha256 = "sha256-IF0VnFh3UeJ6pB/DvwlKXzivZqRYzOE4/39qHNcPVcc=";
  };

  cargoSha256 = "sha256-9XUZL34yHNIOq9Z9xP2+h8C4KUMkl8wAZbKnzppn300=";

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

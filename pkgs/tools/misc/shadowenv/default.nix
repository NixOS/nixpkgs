{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    hash = "sha256-NKqoeJ2sejbe7Gghk3H7oJtP16SX1PcIIjsh/bZdTfQ=";
  };

  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-CGAwb+UduM2QKne2bPntOcFnaUQN/3uUANc6z7f/Oig=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage man/man1/shadowenv.1
    installManPage man/man5/shadowlisp.5
    installShellCompletion --bash sh/completions/shadowenv.bash
    installShellCompletion --fish sh/completions/shadowenv.fish
    installShellCompletion --zsh sh/completions/_shadowenv
  '';

  preCheck = ''
    HOME=$TMPDIR
  '';

  meta = with lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "shadowenv";
  };
}

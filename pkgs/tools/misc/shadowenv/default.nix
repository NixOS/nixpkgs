{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    hash = "sha256-9K04g2DCADkRwjo55rDwVwkvmypqujdN1fqOmHmC09E=";
  };

  cargoHash = "sha256-GBqxA49H3KG63hn8QfM4U8m9uZ1YAhJio6bGziyLvV0=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

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
    maintainers = [ ];
    mainProgram = "shadowenv";
  };
}

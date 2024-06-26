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
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    hash = "sha256-SYVVP1WOadsgucHo3z5QxbGtzczfiej4C3/EmbrHOhg=";
  };

  cargoHash = "sha256-x4OQa84cIKzx29lMx56GfqSFE216jD897g4VhkiV4Kc=";

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
    maintainers = [ ];
    mainProgram = "shadowenv";
  };
}

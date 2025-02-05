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
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    hash = "sha256-ZipFcwTpKKFnQWOPxXg07V71jitG0NSLpGLEzUSsUFA=";
  };

  cargoHash = "sha256-iCAPhCn4dKm+uheF0DvGyLBeZXlKhr+J6LRxsOUg1xU=";

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

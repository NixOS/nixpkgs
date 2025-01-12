{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.24.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-h4GaOZ9wHhRq8/GRKrXkH7fJPpOdYmwZ2nQPsVzt66U=";
  };

  cargoHash = "sha256-dtl1YCMZdNtgaR8TxT3UZ7+CYREzpjaxmT80C1VTTa8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    mainProgram = "kubie";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}

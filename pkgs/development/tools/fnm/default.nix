{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
  version = "1.38.1";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WW+jWaClDn78Fw/xj6WvnEUlBI99HA5hQFUpwsYKmbI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-InukV9tey9fVBj2tDff9HMQ149mXJCPJ85B1fMKyIJ0=";

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = {
    description = "Fast and simple Node.js version manager";
    mainProgram = "fnm";
    homepage = "https://github.com/Schniz/fnm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kidonng ];
  };
}

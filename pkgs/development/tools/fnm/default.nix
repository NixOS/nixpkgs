{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  DiskArbitration,
  Foundation,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
  version = "1.37.2";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RU9GJIn5yTZU6GsIZVQVMtIXnD9ZjmkLWk/V8ZnSXNY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    DiskArbitration
    Foundation
    Security
  ];

  cargoHash = "sha256-2opSyfEuFTS3QZbrk0SOMeiRc+rQTWvm2vqSHyGeFns=";

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = with lib; {
    description = "Fast and simple Node.js version manager";
    mainProgram = "fnm";
    homepage = "https://github.com/Schniz/fnm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kidonng ];
  };
}

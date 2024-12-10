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
  version = "1.35.1";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qRnxXh3m/peMNAR/EV+lkwDI+Z6komF8GGFyF5UDOFg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    Security
  ];

  cargoHash = "sha256-//DCxAC8Jf7g8SkG4NfwkM0NyWUdASuw1g4COFIY0mU=";

  doCheck = false;

  postInstall = ''
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

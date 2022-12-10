{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, libxcb
, openssl
  # Darwin dependencies
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "didyoumean";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "hisbaan";
    repo = "didyoumean";
    rev = "v${version}";
    sha256 = "sha256-hHl9PGNDFN7Dad2JOlAy99dz0pC9OmphwYMJHBBwx7Y=";
  };

  cargoSha256 = "sha256-rjkj9MO6fXVOk3fA87olGt/iIaJ8Zv/cy/Cqy/pg6yI=";

  nativeBuildInputs = [
    installShellFiles
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    libxcb
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
  ];

  postInstall = ''
    installManPage man/dym.1
    installShellCompletion completions/dym.{bash,fish}
    installShellCompletion --zsh completions/_dym
  '';

  # Clipboard doesn't exist in test environment
  doCheck = false;

  meta = with lib; {
    description = "A CLI spelling corrector for when you're unsure";
    homepage = "https://github.com/hisbaan/didyoumean";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ evanjs wegank ];
    mainProgram = "dym";
  };
}

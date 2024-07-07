{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hC4VKEgrAVuqOX7b24XhtrxrnJW5kmlX4E6QbY9H8OA=";
  };

  cargoHash = "sha256-IhCuWCaSU7c7Tot4uvxE7oabY69wDLstuBN35OzkQcU=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage gen/sd.1

    installShellCompletion gen/completions/sd.{bash,fish}
    installShellCompletion --zsh gen/completions/_sd
  '';

  meta = with lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    mainProgram = "sd";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    maintainers = with maintainers; [ amar1729 Br1ght0ne ];
  };
}

{ lib, rustPlatform, fetchFromGitHub, installShellFiles, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "sic-image-cli";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "sic";
    rev = "v${version}";
    sha256 = "sha256-lFb1roQd6CK/9fKWO4SC0CbOLZglB+pS9ZqTdGRHk0Y=";
  };

  cargoSha256 = "sha256-9m8gdbrVv+6tGMg1GTUPy4eRqRQa9zy9BZwfZqNqSS0=";

  nativeBuildInputs = [ installShellFiles nasm ];

  postBuild = ''
    cargo run --example gen_completions
  '';

  postInstall = ''
    installShellCompletion sic.{bash,fish}
    installShellCompletion --zsh _sic
  '';

  meta = with lib; {
    description = "Accessible image processing and conversion from the terminal";
    homepage = "https://github.com/foresterre/sic-image-cli";
    changelog = "https://github.com/foresterre/sic/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "sic";
  };
}

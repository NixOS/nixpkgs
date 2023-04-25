{ lib, rustPlatform, fetchFromGitHub, installShellFiles, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "sic-image-cli";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "sic";
    rev = "v${version}";
    sha256 = "sha256-qUhxJw6c1WBJRS1lNg0opux5ePoVlDCLOWUHRCWgkBk=";
  };

  cargoSha256 = "sha256-ZhEI6yTOVu1dAIoJhKfE3YiM9QJPnhLd49irmPfNLDM=";

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
    homepage = "https://github.com/foresterre/sic";
    changelog = "https://github.com/foresterre/sic/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "sic";
  };
}

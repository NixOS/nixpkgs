{ lib, rustPlatform, fetchFromGitHub, installShellFiles, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "sic-image-cli";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "sic";
    rev = "v${version}";
    sha256 = "sha256-JSBvHbqGTwjiKRPuomXtFLgu77ZB4bOlV/JgzIxaWC0=";
  };

  cargoSha256 = "sha256-HWnYBLxiz7Kd5rmgTFeIG8XtiRzhRKuo/vunJRPLdWU=";

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

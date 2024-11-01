{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "1password";
    repo = "typeshare";
    rev = "v${version}";
    hash = "sha256-hzlrhawHQOM12pYAHqmkk+PPI/3tJx8rFFQ9+znv9c8=";
  };

  cargoHash = "sha256-yHtKgQZlKJ/vmecjzMHkmA/0sbiNJdP0zoUSIowWttQ=";

  nativeBuildInputs = [ installShellFiles ];

  buildFeatures = [ "go" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd typeshare \
      --bash <($out/bin/typeshare completions bash) \
      --fish <($out/bin/typeshare completions fish) \
      --zsh <($out/bin/typeshare completions zsh)
  '';

  meta = with lib; {
    description = "Command Line Tool for generating language files with typeshare";
    mainProgram = "typeshare";
    homepage = "https://github.com/1password/typeshare";
    changelog = "https://github.com/1password/typeshare/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

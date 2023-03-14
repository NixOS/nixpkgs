{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "1password";
    repo = "typeshare";
    rev = "v${version}";
    hash = "sha256-FQ9KL8X7zz3ew+H1lhh4bkZ01Te1TD+QXAMxS8dXAaI=";
  };

  cargoHash = "sha256-t6tGNHmPasmTRto2hobvJywrF/8tO79zkfWwa6lCPK8=";

  nativeBuildInputs = [ installShellFiles ];

  buildFeatures = [ "go" ];

  postInstall = ''
    installShellCompletion --cmd typeshare \
      --bash <($out/bin/typeshare completions bash) \
      --fish <($out/bin/typeshare completions fish) \
      --zsh <($out/bin/typeshare completions zsh)
  '';

  meta = with lib; {
    description = "Command Line Tool for generating language files with typeshare";
    homepage = "https://github.com/1password/typeshare";
    changelog = "https://github.com/1password/typeshare/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "1password";
    repo = "typeshare";
    rev = "v${version}";
    hash = "sha256-20IaTC0fMt6ADSwyQh9yBn3i3z6cmQ1j/wy1KNB3Dog=";
  };

  cargoHash = "sha256-5jY4GO/EbBokE9p9e68bTKj6nJ0LhtWYHtFGfTIf9Po=";

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
    mainProgram = "typeshare";
    homepage = "https://github.com/1password/typeshare";
    changelog = "https://github.com/1password/typeshare/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

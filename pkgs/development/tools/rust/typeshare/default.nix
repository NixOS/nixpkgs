{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "1password";
    repo = "typeshare";
    rev = "v${version}";
    hash = "sha256-vKjSpjbjTY9YxJGtqyoat6qI9ipmou+HQt35Dhpgk4E=";
  };

  cargoHash = "sha256-dnQttsI6v90TJD8MekaLV63ltl147zBCe3mmfWj6cxs=";

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

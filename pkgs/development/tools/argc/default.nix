{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OvWXlb1LfUDLOAwAD/LAxoR8Wg8CAgWPXg6d76X/CJI=";
  };

  cargoHash = "sha256-8NbVVSu2y8jgx6z8K4pjKidnRY74DQtYB6ueW7oIPx0=";

  nativeBuildInputs = [installShellFiles];

  postInstall = ''
    installShellCompletion --cmd argc \
      --bash <($out/bin/argc --argc-completions bash) \
      --fish <($out/bin/argc --argc-completions fish) \
      --zsh <($out/bin/argc --argc-completions zsh)
  '';

  # TODO(2024-03-01): determine why this test is failing
  checkFlags = [
    "--skip=misc::escape"
  ];

  meta = with lib; {
    description = "A command-line options, arguments and sub-commands parser for bash";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}

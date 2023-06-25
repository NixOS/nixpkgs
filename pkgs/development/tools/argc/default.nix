{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jtE1OwDEo533wGY1zya09LscED6zyjn0qu+HxyWXO1E=";
  };

  cargoHash = "sha256-+K551Am9sHUj/+0aFVxuf8/M/pnqofoVLPqqnBZWOZA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd argc \
      --bash <($out/bin/argc --argc-completions bash) \
      --fish <($out/bin/argc --argc-completions fish) \
      --zsh <($out/bin/argc --argc-completions zsh)
  '';

  meta = with lib; {
    description = "A command-line options, arguments and sub-commands parser for bash";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}

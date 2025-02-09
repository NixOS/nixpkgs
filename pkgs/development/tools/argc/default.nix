{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Li/K5/SLG6JuoRJDz2DQoj1Oi9LQgZWHNvtZ1HVbj88=";
  };

  cargoHash = "sha256-D1T9FWTvwKtAYoqFlR2OmLRLGWhPJ9D8J7lq/QKcBoM=";

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

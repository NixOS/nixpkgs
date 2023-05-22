{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, rust
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-db75OoFmsR03lK99vGg8+fHJENOyoDFo+uqQJNYmI9M=";
  };

  cargoHash = "sha256-6TC4RWDcg4el+jkq8Jal0k+2sdNsjMkMYqP/b9wP5mU=";

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export PATH=target/${rust.toRustTarget stdenv.hostPlatform}/release:$PATH
  '';

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

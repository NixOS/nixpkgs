{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
, nix-update-script
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "twm";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = "twm";
    rev = "refs/tags/v${version}";
    hash = "sha256-qOOEeaxae7nYbvNzl3BEZkdjO69lgtGrrLS5Q7akN9U=";
  };

  cargoHash = "sha256-gJ5go9V8c97pQZICUD1ksLJhOyJXyVXAWssH3fhrRVQ=";

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion --cmd twm \
      --bash <($out/bin/twm --print-bash-completion) \
      --zsh <($out/bin/twm --print-zsh-completion) \
      --fish <($out/bin/twm --print-fish-completion)

    $out/bin/twm --print-man > twm.1
    installManPage twm.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers =  [ lib.maintainers.vinnymeller ];
    mainProgram = "twm";
  };
}

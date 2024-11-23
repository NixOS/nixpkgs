{ lib, stdenv, rustPlatform, fetchCrate, installShellFiles
, libgpg-error, gpgme, gettext, openssl, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sheesy-cli";
  version = "4.0.11";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-rJ/V9pJgmqERgjD0FQ/oqhZQlIeN4/3ECx15/FOUQdA=";
  };

  cargoHash = "sha256-o2XRvzw54x6xv81l97s1hwc2MC0Ioeyheoz3F+AtKpU=";
  cargoDepsName = pname;

  nativeBuildInputs = [ libgpg-error gpgme gettext installShellFiles ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  buildFeatures = [ "vault" "extract" "completions" "substitute" "process" ];

  checkFeatures = [ ];

  cargoBuildFlags = [ "--bin" "sy" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sy \
      --bash <($out/bin/sy completions bash) \
      --fish <($out/bin/sy completions fish) \
      --zsh <($out/bin/sy completions zsh)
  '';

  meta = with lib; {
    description = "'share-secrets-safely' CLI to interact with GPG/pass-like vaults";
    homepage = "https://share-secrets-safely.github.io/cli/";
    changelog = "https://github.com/share-secrets-safely/cli/releases/tag/${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ devhell ];
    mainProgram = "sy";
  };
}

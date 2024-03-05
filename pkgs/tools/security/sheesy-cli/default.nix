{ lib, stdenv, rustPlatform, fetchCrate, installShellFiles
, libgpg-error, gpgme, gettext, openssl, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sheesy-cli";
  version = "4.0.11";

  src = fetchCrate {
    inherit version pname;
    sha256 = "1l21ji9zqy8x1g2gvqwdhya505max07ibx1hh88s36k0jbvdb7xc";
  };

  cargoSha256 = "159a5ph1gxwcgahyr8885lq3c1w76nxzfrfdpyqixqrr7jzx2rd3";
  cargoDepsName = pname;

  nativeBuildInputs = [ libgpg-error gpgme gettext installShellFiles ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  buildFeatures = [ "vault" "extract" "completions" "substitute" "process" ];

  checkFeatures = [ ];

  cargoBuildFlags = [ "--bin" "sy" ];

  postInstall = ''
    installShellCompletion --cmd sy \
      --bash <($out/bin/sy completions bash) \
      --fish <($out/bin/sy completions fish) \
      --zsh <($out/bin/sy completions zsh)
  '';

  meta = with lib; {
    description = "The 'share-secrets-safely' CLI to interact with GPG/pass-like vaults";
    homepage = "https://share-secrets-safely.github.io/cli/";
    changelog = "https://github.com/share-secrets-safely/cli/releases/tag/${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ devhell ];
    mainProgram = "sy";
  };
}

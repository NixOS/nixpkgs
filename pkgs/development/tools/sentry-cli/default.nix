{ rustPlatform
, fetchFromGitHub
, lib
, installShellFiles
, openssl
, pkg-config
, stdenv
, CoreServices
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.28.6";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-cynq7w0xLnLafStcfrG27PNHVoMu4TxFIwwrWjj9ynM=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  cargoHash = "sha256-MChhtWbwi5/1GMXxlKov8LrO+kp7D6u4u1lmEjZvyP8=";

  postInstall = ''
    installShellCompletion --cmd sentry-cli \
        --bash <($out/bin/sentry-cli completions bash) \
        --fish <($out/bin/sentry-cli completions fish) \
        --zsh <($out/bin/sentry-cli completions zsh)
  '';

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary loewenheim ];
  };
}

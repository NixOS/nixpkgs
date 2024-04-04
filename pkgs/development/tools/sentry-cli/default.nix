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
  version = "2.30.4";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-J+8/sCFSd2BYQgKOl8OZoxlFLB8scDY5Bl7GAQ54/RM=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  cargoHash = "sha256-622cEaHEMmVspabsIYgQ5ySbaDr9qB1FjxJ5NwbeGx8=";

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
    mainProgram = "sentry-cli";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary loewenheim ];
  };
}

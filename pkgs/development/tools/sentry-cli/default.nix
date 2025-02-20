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
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    hash = "sha256-iEOPHXJ3fgI7wvKIG7uXUOh8/FajVZIZzTIOzLFiKWE=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices Security SystemConfiguration ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-WjGy2dUl9f1LPvCCJD3Y6Xr5QrYja37etIL0TsggLwA=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sentry-cli \
        --bash <($out/bin/sentry-cli completions bash) \
        --fish <($out/bin/sentry-cli completions fish) \
        --zsh <($out/bin/sentry-cli completions zsh)
  '';

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "Command line utility to work with Sentry";
    mainProgram = "sentry-cli";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary ];
  };
}

{ rustPlatform, fetchFromGitHub, installShellFiles, lib, openssl, pkg-config
, stdenv, Security, SystemConfiguration }:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.21.3";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-qT32d+21vdP+CvserBXnMbMlYu3ZFVNS54hUHOFWQjU=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  postInstall = ''
    installShellCompletion --cmd sentry-cli \
        --bash <($out/bin/sentry-cli completions bash) \
        --fish <($out/bin/sentry-cli completions fish) \
        --zsh <($out/bin/sentry-cli completions zsh)
  '';

  cargoHash = "sha256-7LCbeyTZf//5xVlSOU8EQj9xTmXZuDJ2KKPdioX67Uk=";

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry";
    changelog =
      "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary loewenheim ];
  };
}

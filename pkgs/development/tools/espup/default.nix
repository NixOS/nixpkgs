{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, bzip2
, openssl
, xz
, zstd
, stdenv
, darwin
, testers
, espup
}:

rustPlatform.buildRustPackage rec {
  pname = "espup";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espup";
    rev = "v${version}";
    hash = "sha256-2LSlnGte65eemlDw67mPhmf+RuLwnbavNyMYMLgrx/E=";
  };

  cargoHash = "sha256-4Gm8nQIsZzaPYtqf7eAyX0iX0rUFBnEiavJR1qcc8/g=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    bzip2
    openssl
    xz
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # makes network calls
    "--skip=toolchain::rust::tests::test_xtensa_rust_parse_version"
  ];

  postInstall = ''
    installShellCompletion --cmd espup \
      --bash <($out/bin/espup completions bash) \
      --fish <($out/bin/espup completions fish) \
      --zsh <($out/bin/espup completions zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = espup;
  };

  meta = with lib; {
    description = "Tool for installing and maintaining Espressif Rust ecosystem.";
    homepage = "https://github.com/esp-rs/espup/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ knightpp ];
    mainProgram = "espup";
  };
}

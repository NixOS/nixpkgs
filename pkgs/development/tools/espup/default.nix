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
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espup";
    rev = "v${version}";
    hash = "sha256-cbBfzx195zk98IbSNSx99CF1RqH+ySpy6SQk5y8rvq4=";
  };

  cargoHash = "sha256-N1TpBN5wULY+brBxUfwFrBTLKrVI8Cq3OX8fJqLHwAI=";

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
    darwin.apple_sdk.frameworks.SystemConfiguration
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
    description = "Tool for installing and maintaining Espressif Rust ecosystem";
    homepage = "https://github.com/esp-rs/espup/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ knightpp beeb ];
    mainProgram = "espup";
  };
}

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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espup";
    rev = "v${version}";
    hash = "sha256-D5ck96nR8agiYf1t6ViOaEWws9AQ0EBZ48YKp68jfRA=";
  };

  cargoHash = "sha256-mKpAGS6Rxoq2v/VW0AncVx/9BjvG7wM8ePTR+661e5U=";

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
    description = "Tool for installing and maintaining Espressif Rust ecosystem.";
    homepage = "https://github.com/esp-rs/espup/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ knightpp ];
    mainProgram = "espup";
  };
}

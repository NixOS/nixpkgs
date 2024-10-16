{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    hash = "sha256-7Wavhl5irQU9OV7+dslrIQEAcsaqJZ/jWmxaCyTBsEs=";
  };

  cargoHash = "sha256-WCbpwvCXm54/Cv+TscaqseWzTUd8V1DxmS30fUZZTwI=";

  # use OpenSSL for the TLS backend instead of the default rustls
  buildNoDefaultFeatures = true;
  buildFeatures = [ "native-tls" ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = ''
    installShellCompletion --cmd tldr \
      --bash completion/bash_tealdeer \
      --fish completion/fish_tealdeer \
      --zsh completion/zsh_tealdeer
  '';

  # Disable tests that require Internet access:
  checkFlags = [
    "--skip test_autoupdate_cache"
    "--skip test_create_cache_directory_path"
    "--skip test_pager_flag_enable"
    "--skip test_quiet_cache"
    "--skip test_quiet_failures"
    "--skip test_quiet_old_cache"
    "--skip test_spaces_find_command"
    "--skip test_update_cache"
  ];

  meta = with lib; {
    description = "Very fast implementation of tldr in Rust";
    homepage = "https://github.com/dbrgn/tealdeer";
    maintainers = with maintainers; [ davidak newam mfrw ];
    license = with licenses; [ asl20 mit ];
    mainProgram = "tldr";
  };
}

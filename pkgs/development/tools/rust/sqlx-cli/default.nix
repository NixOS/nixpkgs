{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
, libiconv
, testers
, sqlx-cli
, CoreFoundation
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    hash = "sha256-AKVNyuV9jwzmsy6tHkGkLj1fhVT8XYvEn2Ip2wCKDxI=";
  };

  cargoHash = "sha256-F3FLu/n57F8psk+d0Hf+HnqV/DvEFQwRefu/4C8A1sU=";

  # Prepare the Cargo.lock for offline use.
  # See https://github.com/NixOS/nixpkgs/issues/261412
  postConfigure = ''
    cargo metadata --offline > /dev/null
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "native-tls"
    "postgres"
    "sqlite"
    "mysql"
    "completions"
  ];

  doCheck = false;
  cargoBuildFlags = [ "--package sqlx-cli" ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.isLinux [
      openssl
    ] ++
    lib.optionals stdenv.isDarwin [
      CoreFoundation
      Security
      SystemConfiguration
      libiconv
    ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/sqlx completions $shell > sqlx.$shell
      installShellCompletion sqlx.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = sqlx-cli;
    command = "sqlx --version";
  };

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh xrelkd fd ];
    mainProgram = "sqlx";
  };
}

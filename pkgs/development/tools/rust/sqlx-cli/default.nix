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
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    hash = "sha256-hxqd0TrsKANCPgQf6JUP0p1BYhZdqfnWbtCQCBxF8Gs=";
  };

  cargoHash = "sha256-jDwfFHC19m20ECAo5VbFI6zht4gnZMYqTKsbyoVJJZU=";

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
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ] ++
    lib.optionals stdenv.hostPlatform.isDarwin [
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh xrelkd fd ];
    mainProgram = "sqlx";
  };
}

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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    hash = "sha256-q1o2pNKfvenpRwiYgIKkOYNcajgIhrhCjFC7bbEyLE4=";
  };

  cargoHash = "sha256-sMyK1v4pJmmlN47mvgUkpLBjcpmT346VSp984IpvVWY=";

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

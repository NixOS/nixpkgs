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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    hash = "sha256-567/uJPQhrNqDqBF/PqklXm2avSjvtQsddjChwUKUCI=";
  };

  cargoHash = "sha256-X7fLbih1s3sxn8vb2kQeFUKDK2DlC+sjm9ZTwj3FD1Y=";

  doCheck = false;
  cargoBuildFlags = [ "--package sqlx-cli --no-default-features --features native-tls,postgres,sqlite,mysql,completions" ];

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

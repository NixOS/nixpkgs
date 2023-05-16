{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, installShellFiles
, pkg-config
, openssl
, libiconv
, testers
, sqlx-cli
, CoreFoundation
, Security
, SystemConfiguration
=======
, fetchpatch
, pkg-config
, openssl
, SystemConfiguration
, CoreFoundation
, Security
, libiconv
, testers
, sqlx-cli
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
<<<<<<< HEAD
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
=======
    sha256 = "sha256-pQlrKjhOJfjNEmLxqnFmmBY1naheZUsaq2tGdLKGxjg=";
  };

  patches = [
    # https://github.com/launchbadge/sqlx/pull/2228
    (fetchpatch {
      name = "fix-rust-1.65-compile.patch";
      url = "https://github.com/launchbadge/sqlx/commit/2fdf85b212332647dc4ac47e087df946151feedf.patch";
      hash = "sha256-5BCuIwmECe9qQrdYll7T+UOGwuTBolWEhKNE7GcZqJw=";
    })
  ];

  cargoSha256 = "sha256-AbA8L7rkyZfKW0vvjyrcW5eU6jGD+zAqIcEUOJmeqJs=";

  doCheck = false;
  cargoBuildFlags = [ "-p sqlx-cli" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration CoreFoundation Security libiconv ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests.version = testers.testVersion {
    package = sqlx-cli;
    command = "sqlx --version";
  };

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ greizgh xrelkd fd ];
    mainProgram = "sqlx";
=======
    maintainers = with maintainers; [ greizgh ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

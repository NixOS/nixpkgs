{ lib
, sqliteSupport ? true
, postgresqlSupport ? true
, mysqlSupport ? true
, rustPlatform
, fetchCrate
, installShellFiles
, pkg-config
, openssl
, stdenv
, Security
, libiconv
, sqlite
, postgresql
, mariadb
, zlib
}:

assert lib.assertMsg (sqliteSupport == true || postgresqlSupport == true || mysqlSupport == true)
  "support for at least one database must be enabled";

let
  inherit (lib) optional optionals optionalString;
in

rustPlatform.buildRustPackage rec {
  pname = "diesel-cli";
  version = "2.1.1";

  src = fetchCrate {
    inherit version;
    crateName = "diesel_cli";
    hash = "sha256-fpvC9C30DJy5ih+sFTTMoiykUHqG6OzDhF9jvix1Ctg=";
  };

  cargoHash = "sha256-nPmUCww8sOJwnG7+uIflLPgT87xPX0s7g0AcuDKhY2I=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ]
    ++ optional stdenv.isDarwin Security
    ++ optional (stdenv.isDarwin && mysqlSupport) libiconv
    ++ optional sqliteSupport sqlite
    ++ optional postgresqlSupport postgresql
    ++ optionals mysqlSupport [ mariadb zlib ];

  buildNoDefaultFeatures = true;
  buildFeatures = optional sqliteSupport "sqlite"
    ++ optional postgresqlSupport "postgres"
    ++ optional mysqlSupport "mysql";

  checkPhase = ''
    runHook preCheck
  '' + optionalString sqliteSupport ''
    cargo check --features sqlite
  '' + optionalString postgresqlSupport ''
    cargo check --features postgres
  '' + optionalString mysqlSupport ''
    cargo check --features mysql
  '' + ''
    runHook postCheck
  '';

  postInstall = ''
    installShellCompletion --cmd diesel \
      --bash <($out/bin/diesel completions bash) \
      --fish <($out/bin/diesel completions fish) \
      --zsh <($out/bin/diesel completions zsh)
  '';

  # Fix the build with mariadb, which otherwise shows "error adding symbols:
  # DSO missing from command line" errors for libz and libssl.
  NIX_LDFLAGS = optionalString mysqlSupport "-lz -lssl -lcrypto";

  meta = with lib; {
    description = "Database tool for working with Rust projects that use Diesel";
    homepage = "https://github.com/diesel-rs/diesel/tree/master/diesel_cli";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ];
    mainProgram = "diesel";
  };
}

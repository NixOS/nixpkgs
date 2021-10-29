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
  features = optional sqliteSupport "sqlite"
    ++ optional postgresqlSupport "postgres"
    ++ optional mysqlSupport "mysql";
in

rustPlatform.buildRustPackage rec {
  pname = "diesel-cli";
  version = "1.4.1";

  src = fetchCrate {
    inherit version;
    crateName = "diesel_cli";
    sha256 = "sha256-mRdDc4fHMkwkszY+2l8z1RSNMEQnrWI5/Y0Y2W+guQE=";
  };

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];
  cargoSha256 = "sha256-sQ762Ss31sA5qALHzwkvwbfRXo00cCtqzQyoz3/zf6I=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ]
    ++ optional stdenv.isDarwin Security
    ++ optional (stdenv.isDarwin && mysqlSupport) libiconv
    ++ optional sqliteSupport sqlite
    ++ optional postgresqlSupport postgresql
    ++ optionals mysqlSupport [ mariadb zlib ];

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

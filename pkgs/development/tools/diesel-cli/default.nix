{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security
, sqliteSupport ? true, sqlite
, postgresqlSupport ? true, postgresql
, mysqlSupport ? true, mariadb, zlib, libiconv
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

  src = fetchFromGitHub {
    owner = "diesel-rs";
    repo = "diesel";
    # diesel and diesel_cli are independently versioned. diesel_cli
    # 1.4.1 first became available in diesel 1.4.5, but we can use
    # a newer diesel tag.
    rev = "v1.4.6";
    sha256 = "0c8a2f250mllzpr20j7j0msbf2csjf9dj8g7j6cl04ifdg7gwb9z";
  };

  patches = [
    # Fixes:
    #    Compiling diesel v1.4.6 (/build/source/diesel)
    # error: this `#[deprecated]` annotation has no effect
    #    --> diesel/src/query_builder/insert_statement/mod.rs:205:1
    #     |
    # 205 | / #[deprecated(
    # 206 | |     since = "1.2.0",
    # 207 | |     note = "Use `<&'a [U] as Insertable<T>>::Values` instead"
    # 208 | | )]
    #     | |__^ help: remove the unnecessary deprecation attribute
    #     |
    #     = note: `#[deny(useless_deprecated)]` on by default
    ./fix-deprecated.patch
  ];

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "060r90dvdi0s5v3kjagsrrdb4arzzbkin8v5563rdpv0sq1pi3bm";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ optional stdenv.isDarwin Security
    ++ optional (stdenv.isDarwin && mysqlSupport) libiconv
    ++ optional sqliteSupport sqlite
    ++ optional postgresqlSupport postgresql
    ++ optionals mysqlSupport [ mariadb zlib ];

  buildAndTestSubdir = "diesel_cli";

  checkPhase = optionalString sqliteSupport ''
    (cd diesel_cli && cargo check --features sqlite)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/diesel --version
  '';

  # Fix the build with mariadb, which otherwise shows "error adding symbols:
  # DSO missing from command line" errors for libz and libssl.
  NIX_LDFLAGS = optionalString mysqlSupport "-lz -lssl -lcrypto";

  meta = with lib; {
    description = "Database tool for working with Rust projects that use Diesel";
    homepage = "https://github.com/diesel-rs/diesel/tree/master/diesel_cli";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ];
  };
}

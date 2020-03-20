{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkgconfig, Security
, sqliteSupport ? true, sqlite
, postgresqlSupport ? true, postgresql
, mysqlSupport ? true, mysql, zlib, libiconv
}:

assert lib.assertMsg (sqliteSupport == true || postgresqlSupport == true || mysqlSupport == true)
  "support for at least one database must be enabled";

let
  inherit (stdenv.lib) optional optionals optionalString;
  features = ''
    ${optionalString sqliteSupport "sqlite"} \
    ${optionalString postgresqlSupport "postgres"} \
    ${optionalString mysqlSupport "mysql"} \
  '';
in

rustPlatform.buildRustPackage rec {
  pname = "diesel-cli";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "diesel-rs";
    repo = "diesel";
    rev = "v${version}";
    sha256 = "0wp4hvpl9cf8hw1jyz3z476k5blrh6srfpv36dw10bj126rz9pvb";
  };

  patches = [
    # Allow warnings to fix many instances of `error: trait objects without an explicit `dyn` are deprecated`
    #
    # Remove this after https://github.com/diesel-rs/diesel/commit/9004d1c3fa12aaee84986bd3d893002491373f8c
    # is in a release.
    ./allow-warnings.patch
  ];

  cargoBuildFlags = [ "--no-default-features --features \"${features}\"" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1vbb7r0dpmq8363i040bkhf279pz51c59kcq9v5qr34hs49ish8g";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
    ++ optional stdenv.isDarwin Security
    ++ optional (stdenv.isDarwin && mysqlSupport) libiconv
    ++ optional sqliteSupport sqlite
    ++ optional postgresqlSupport postgresql
    ++ optionals mysqlSupport [ mysql zlib ];

  # We must `cd diesel_cli`, we cannot use `--package diesel_cli` to build
  # because --features fails to apply to the package:
  # https://github.com/rust-lang/cargo/issues/5015
  # https://github.com/rust-lang/cargo/issues/4753
  preBuild = "cd diesel_cli";
  postBuild = "cd ..";

  checkPhase = optionalString sqliteSupport ''
    (cd diesel_cli && cargo check --features sqlite)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/diesel --version
  '';

  # Fix the build with mariadb, which otherwise shows "error adding symbols:
  # DSO missing from command line" errors for libz and libssl.
  NIX_LDFLAGS = lib.optionalString mysqlSupport "-lz -lssl -lcrypto";

  meta = with lib; {
    description = "Database tool for working with Rust projects that use Diesel";
    homepage = https://github.com/diesel-rs/diesel/tree/master/diesel_cli;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}

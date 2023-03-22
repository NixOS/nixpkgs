{ darwin
, fetchFromGitHub
, lib
, libiconv
, libpg_query
, openssl
, pkg-config
, rustPlatform
, stdenv
}:
let
  # The query parser produces a slightly different AST between major versions
  # and Squawk is not capable of handling >=14 correctly yet.
  libpg_query13 = libpg_query.overrideAttrs (_: rec {
    version = "13-2.2.0";
    src = fetchFromGitHub {
      owner = "pganalyze";
      repo = "libpg_query";
      rev = version;
      hash = "sha256-gEkcv/j8ySUYmM9lx1hRF/SmuQMYVHwZAIYOaCQWAFs=";
    };
  });
in
rustPlatform.buildRustPackage rec {
  pname = "squawk";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ObaYGGTAGGLOAji86Q5R9fqbCGg6GP0A3iheNLgzezY=";
  };

  cargoHash = "sha256-VOGgwBKcJK7x+PwvzvuVu9Zd1G8t9UoC/Me3G6bdtrk=";

  cargoPatches = [
    ./correct-Cargo.lock.patch
  ];

  patches = [
    ./fix-postgresql-version-in-snapshot-test.patch
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals (!stdenv.isDarwin) [
    libiconv
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    Security
  ]);

  OPENSSL_NO_VENDOR = 1;

  LIBPG_QUERY_PATH = libpg_query13;

  meta = with lib; {
    description = "Linter for PostgreSQL, focused on migrations";
    homepage = "https://squawkhq.com/";
    changelog = "https://github.com/sbdchd/squawk/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewsmith ];
  };
}

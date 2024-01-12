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

rustPlatform.buildRustPackage rec {
  pname = "squawk";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RnY41G0ombqJewv+kxvg8AwQeRaVb+frZjmU/Cd28Jo=";
  };

  cargoHash = "sha256-YR2ZSwrCkX8eyHTj1Dtk9f01/y9fDtknouige68kS8I=";

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

  LIBPG_QUERY_PATH = libpg_query;

  checkFlags = [
    # depends on the PostgreSQL version
    "--skip=parse::tests::test_parse_sql_query_json"
  ];

  meta = with lib; {
    description = "Linter for PostgreSQL, focused on migrations";
    homepage = "https://squawkhq.com/";
    changelog = "https://github.com/sbdchd/squawk/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewsmith marsam ];
  };
}

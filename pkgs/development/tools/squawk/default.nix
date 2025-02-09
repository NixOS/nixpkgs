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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ibgtgzpdNwQk/X5xz3XOM6Wi9xA8v4DAnj/86UKnXXk=";
  };

  cargoHash = "sha256-d2txSyTVU6CAnItpRttgOcDeH/8mVuPL636h/g67qgg=";

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

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
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "sbdchd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WhlFqsFJBVtGrB6MWenCZi0eUorglb7PUbOf16JCybk=";
  };

  cargoHash = "sha256-Ul5D+xZjNNZl83jQeU4jJId5dZLVWbtZv05c40KMctU=";

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

  meta = with lib; {
    description = "Linter for PostgreSQL, focused on migrations";
    homepage = "https://squawkhq.com/";
    changelog = "https://github.com/sbdchd/squawk/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewsmith ];
  };
}

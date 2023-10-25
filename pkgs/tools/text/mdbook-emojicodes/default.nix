{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-emojicodes";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "blyxyas";
    repo = "mdbook-emojicodes";
    rev = "${version}.1";
    hash = "sha256-SWT01R/+FuzkkOUd/2wpRo0HIaPEtzDelTSh7ewo9gQ=";
  };

  cargoHash = "sha256-z9UKBBCr8R1I9k48JsEBnVokQDfaj9lt+qfIUvJ/5lE=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "MDBook preprocessor for converting emojicodes (e.g. `: cat :`) into emojis 🐱";
    homepage = "https://github.com/blyxyas/mdbook-emojicodes";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

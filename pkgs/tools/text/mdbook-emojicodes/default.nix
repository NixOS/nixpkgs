{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-emojicodes";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "blyxyas";
    repo = "mdbook-emojicodes";
    rev = "${version}";
    hash = "sha256-wj3WVDDJmRh1g4E1iqxqmu6QNNVi9pOqZDnnDX3AnFo=";
  };

  cargoHash = "sha256-Ia7GdMadx1Jb1BB040eRmyIpK98CsN3yjruUxUNh3co=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "MDBook preprocessor for converting emojicodes (e.g. `: cat :`) into emojis 🐱";
    homepage = "https://github.com/blyxyas/mdbook-emojicodes";
    changelog = "https://github.com/blyxyas/mdbook-emojicodes/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

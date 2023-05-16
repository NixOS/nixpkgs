{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-emojicodes";
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "blyxyas";
    repo = "mdbook-emojicodes";
<<<<<<< HEAD
    rev = "${version}";
    hash = "sha256-wj3WVDDJmRh1g4E1iqxqmu6QNNVi9pOqZDnnDX3AnFo=";
  };

  cargoHash = "sha256-Ia7GdMadx1Jb1BB040eRmyIpK98CsN3yjruUxUNh3co=";
=======
    rev = "${version}.1";
    hash = "sha256-SWT01R/+FuzkkOUd/2wpRo0HIaPEtzDelTSh7ewo9gQ=";
  };

  cargoHash = "sha256-z9UKBBCr8R1I9k48JsEBnVokQDfaj9lt+qfIUvJ/5lE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "MDBook preprocessor for converting emojicodes (e.g. `: cat :`) into emojis 🐱";
    homepage = "https://github.com/blyxyas/mdbook-emojicodes";
<<<<<<< HEAD
    changelog = "https://github.com/blyxyas/mdbook-emojicodes/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

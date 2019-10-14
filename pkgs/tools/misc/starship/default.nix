{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    sha256 = "189abf5n9k13kv4hl88svmhwv3gla8zrfk9pn8l55m299algcfk1";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "0c82k6aw245vsqkcrg6bhqhylfbxdszcr040mrz7cz9ydxcb58b9";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco ];
    platforms = platforms.all;
  };
}

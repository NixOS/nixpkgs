{ fetchFromGitHub, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "shticker-book-unwritten";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "JonathanHelianthicusDoe";
    repo = "shticker_book_unwritten";
    rev = "v${version}";
    sha256 = "08lyxica0b0vvivybsvzigy2j7saar78mbz723y3g5hqrilfb5np";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1d4mnfzkdbqnjmqk7fl4bsy27lr7wnq997nz0hflaybnx2d3nisn";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
}

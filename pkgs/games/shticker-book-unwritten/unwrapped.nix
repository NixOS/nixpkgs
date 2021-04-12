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
  cargoSha256 = "1lnhdr8mri1ns9lxj6aks4vs2v4fvg7mcriwzwj78inpi1l0xqk5";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
}

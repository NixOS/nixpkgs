{ lib, rustPlatform, fetchCrate, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "shticker-book-unwritten";
  version = "1.2.0";

  src = fetchCrate {
    inherit version;
    crateName = "shticker_book_unwritten";
    sha256 = "sha256-jI2uL8tMUmjZ5jPkCV2jb98qtKwi9Ti4NVCPfuO3iB4=";
  };

  cargoSha256 = "sha256-Tney9SG9MZh7AUIT1h/dlgJyRrSPX7mUhfsKD1Rfsfc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
}

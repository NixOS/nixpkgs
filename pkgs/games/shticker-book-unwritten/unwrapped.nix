{ lib, rustPlatform, fetchCrate, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "shticker-book-unwritten";
  version = "1.0.3";

  src = fetchCrate {
    inherit version;
    crateName = "shticker_book_unwritten";
    sha256 = "sha256-NQEXLTtotrZQmoYQnhCHIEwSe+fqlcHq5/I6zTHwLvc=";
  };

  cargoSha256 = "sha256-SniyLp/4R0MkJYQmW3RFvOFeBKTvRlSzEI5Y+ELHfy8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
}

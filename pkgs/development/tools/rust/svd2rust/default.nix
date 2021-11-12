{ lib, rustPlatform, fetchCrate, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.19.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-LNJd88Gw8HaE1qnRbD7mipVEFgG7jCsyUu9pbwY/4JY=";
  };

  cargoSha256 = "sha256-Qg/wA3R98FAb8UZ5s7GOEgOeifrqwFJ4lg0BC2SZOE8=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ];
  };
}

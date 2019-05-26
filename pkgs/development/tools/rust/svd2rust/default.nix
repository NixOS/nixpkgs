{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "svd2rust-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "svd2rust";
    rev = "v${version}";
    sha256 = "1a0ldmjkhyv5c52gcq8p8avkj0cgj1b367w6hm85bxdf5j4y8rra";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0wsiaa6q9hr9x1cbg6sc8ajg846jjci5qwhdga4d408fmqav72ih";

  # doc tests fail due to missing dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = https://github.com/rust-embedded/svd2rust;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}

{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "svd2rust";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "svd2rust";
    rev = "v${version}";
    sha256 = "1a0ldmjkhyv5c52gcq8p8avkj0cgj1b367w6hm85bxdf5j4y8rra";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0n0xc8b982ra007l6gygssf1n60gfc2rphwyi7n95dbys1chciyg";

  # doc tests fail due to missing dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = https://github.com/rust-embedded/svd2rust;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}

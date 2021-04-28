{ lib, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "svd2rust";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "svd2rust";
    rev = "v${version}";
    sha256 = "0p118dbxnypp99xn2xa382rvwk56a9p4wc6xhpfn8qbg4g43brrd";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "15js131shsqc2f42ixpp9rhmqp08cy03m4fx5l0vp1y6ikhqrqz4";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    license = with licenses; [ mit asl20 ];
  };
}

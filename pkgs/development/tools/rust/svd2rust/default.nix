{ lib, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "svd2rust";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "svd2rust";
    rev = "v${version}";
    sha256 = "1p0zq3q4g9lr0ghavp7v1dwsqq19lkljkm1i2hsb1sk3pxa1f69n";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0c0f86x17fzav5q76z3ha3g00rbgyz2lm5a5v28ggy0jmg9xgsv6";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    license = with licenses; [ mit asl20 ];
  };
}

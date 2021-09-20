{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

with rustPlatform;

buildRustPackage rec {
  pname = "svd2rust";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "svd2rust";
    rev = "v${version}";
    sha256 = "04mm0l7cv2q5yjxrkpr7p0kxd4nmi0d7m4l436q8p492nvgb75zx";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "1v1qx0r3k86jipyaaggm25pinsqicmzvnzrxd0lr5xk77s1kvgid";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    license = with licenses; [ mit asl20 ];
  };
}

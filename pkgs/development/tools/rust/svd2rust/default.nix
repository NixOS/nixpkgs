{ lib, rustPlatform, fetchCrate, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.21.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0mxzbbxrg1jysxpjqcvgwwmh8qf0lyf64fl1gxxp0whph0x279qj";
  };

  cargoSha256 = "0kvya6swx1nsxxlhn2w8x4dhl4j3v56jxqr2h259cx6lzv3xjhin";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ];
  };
}

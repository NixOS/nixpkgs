{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-KfY2ZZ6+wTKWT+kM+pDVVhCWhhyEZZmbTC6iFstl/e8=";
  };

  cargoSha256 = "sha256-hpD/Wb+17TeU8nLGC/fxX+9Na6ve6Ov6VEy11vQA+kY=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

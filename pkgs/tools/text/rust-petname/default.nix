{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rust-petname";
  version = "1.1.2";

  src = fetchCrate {
    inherit version;
    crateName = "petname";
    sha256 = "sha256-DfRWGwnWVJBcbW7aPEzgPd+gfldP+ypZlk8FcPZzp8g=";
  };

  cargoSha256 = "sha256-tCVJX8NcbT+6t2kDeCMfcSDaq3O89ycj08bxTmp3JHs=";

  meta = with lib; {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "petname";
  };
}

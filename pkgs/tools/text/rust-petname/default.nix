{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rust-petname";
  version = "2.0.1";

  src = fetchCrate {
    inherit version;
    crateName = "petname";
    sha256 = "sha256-n/oqQCshxcqQPYNI0GZXGdZmx0Y12l6QKQpsbThdNAA=";
  };

  cargoHash = "sha256-Rzhp+lS0ykJsMdd2Z+oTWjFFWGp+ZX0Cup7Hq2bIbrg=";

  meta = with lib; {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "petname";
  };
}

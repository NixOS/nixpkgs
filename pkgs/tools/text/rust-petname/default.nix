{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rust-petname";
  version = "1.1.3";

  src = fetchCrate {
    inherit version;
    crateName = "petname";
    sha256 = "sha256-C6EJ8awdTV9TecMeYdbmleK8171+hvphjXJrWNJSXxo=";
  };

  cargoSha256 = "sha256-mB4n1IxhNXrAsCz/jv5jgqyO9OgISZnI5E/vFu80+FE=";

  meta = with lib; {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "petname";
  };
}

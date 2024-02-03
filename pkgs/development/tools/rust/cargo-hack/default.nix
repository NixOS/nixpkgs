{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.16";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DbZ/8tnVD9jXN9Ek7LJRF1GFy/gphexNKG7FcZeqtoE=";
  };

  cargoHash = "sha256-j7ZHq3M2JgQV72GRKOIlp+jsoc/ikYHmNLOnrZ2yA8I=";

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

{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.21";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5vWrnujojleGUS7Ays8YX1TncK61+XHEJFqRhfxF3Ow=";
  };

  cargoHash = "sha256-yzunrPAo6/kgEomu5AHk/AB8EFqs96Jal1KHODSlyWc=";

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

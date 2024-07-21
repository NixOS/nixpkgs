{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.29";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9UV+oU+jiv3vpmo2u0DQl9ExjoCEftbqZgjiy8APHro=";
  };

  cargoHash = "sha256-JzkbuPOwisxDk67bBLlTJ/NZkgm7ttCSeamT3/ZZWeA=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

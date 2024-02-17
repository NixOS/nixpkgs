{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.19";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dsuf3+GYsIL6B64Belj6SF9NLsZCd62VkpcDUrnr14U=";
  };

  cargoHash = "sha256-FGZ1Gc7LT1wee2vHMCIo2xvKvz8oj0R6oINAl/y7mKA=";

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

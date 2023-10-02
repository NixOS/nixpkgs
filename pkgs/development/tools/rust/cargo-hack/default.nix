{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZFFrluvnm5kCOyIe4c+gT2N4W7aeg1Cv1666by92BJo=";
  };

  cargoHash = "sha256-Nbs2pE9WqwsTJLV3nUAWVVz6gwcmhyk9hv/uaOoAkIQ=";

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

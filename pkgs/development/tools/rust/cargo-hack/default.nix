{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-EGT2Gi5QXnMIRBNHBv/LpYGmyzZThC7fHX0epyNlTaM=";
  };

  cargoSha256 = "sha256-hoIpc4KJBRoAE7q+HiovwhpYT2lH4UPuwy4pbBGNCag=";

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

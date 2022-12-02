{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.23";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5iFc8wEejCuD8HbaJv2XuZ/LP7aPtGJk+gXTJqAr8aM=";
  };

  cargoSha256 = "sha256-U6F/5VeALxs8YysU4VOLBUCu8d0Iaf3VRE7g2zRTAkg=";

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

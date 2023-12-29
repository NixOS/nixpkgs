{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5WwbtubANrLHXvaWzO/u1NeeetVUvl/ujq89BqFZ2ZQ=";
  };

  cargoHash = "sha256-25I1j0QiyeHtUq6IK7ehRK3JLKygiigtfvEe+N74TgY=";

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

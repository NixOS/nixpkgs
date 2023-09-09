{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-loGQTCi6lTNB/jn47fvWTqKr01p4xRqyq+Y02a/UwSc=";
  };

  cargoSha256 = "sha256-gk/0aTMlUWYKfJJ9CfTvYLTZ6/ShIRuhpywhuwFHD5E=";

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

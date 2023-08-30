{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-kb4ftO4nhQ+MykK18O5aoexuBoN+u0xobUvIEge00jU=";
  };

  cargoSha256 = "sha256-+Am9w3iU2kSAIx+1tK3kpoa+oJvLQ6Ew7LeP6njYEQw=";

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

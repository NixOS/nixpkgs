{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.18";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-EtM5nGbsvwWiQGKrakMiToz7Hy6xoE3C6JsD2+JBpaA=";
  };

  cargoSha256 = "sha256-3O9j9I6iMsgQl1nhXfdI5sNnnt71FBidQh+bqjpuPhc=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/taiki-e/cargo-hack";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

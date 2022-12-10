{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.24";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-brzefn9Nfb4+OnO0gCH5mPbXDdqaFSoqB6phFPwQXoY=";
  };

  cargoSha256 = "sha256-RPQgZoIPFxZGP3Bpwp/VdTYPi5+IdfY3Zy+rYnYev3g=";

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

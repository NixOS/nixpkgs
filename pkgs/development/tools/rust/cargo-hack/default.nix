{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.20";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-V6ENO9KzZXkBF19stySSTLXSWnZym6FXaWjAEHuluQs=";
  };

  cargoSha256 = "sha256-5kIzTO02zurjoU6H+iDif9UV3KY0tPFvvZlg6sNRJwg=";

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

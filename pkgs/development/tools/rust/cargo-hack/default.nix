{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.15";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yjaX4lqUj9aZPkRuiJC3yBwXvfvd+Okr87Ia2IQvxfM=";
  };

  cargoHash = "sha256-6ogeqVN2V38N7mNBjimjNv/KK2JtV4aa5AorRfYMBx8=";

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

{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.26";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ZVR3bycEWpOV4T/85OsERNjKooz2rwBF5kMSEfHnmEI=";
  };

  cargoSha256 = "sha256-4TChr6dKxUerpuaX63WShrWyXTLH4m85P6E30a5rmH8=";

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

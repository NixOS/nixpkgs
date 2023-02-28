{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.27";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-oiCZiwJr1BqMCWCNUOTQT3XPX0QZRr0wLewf8OU6lHA=";
  };

  cargoSha256 = "sha256-g5O51V4BPNqzsQo1prLIpamqwcOy+SJat2Rb5UDHRLc=";

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

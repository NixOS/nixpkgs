{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.18";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SHLYS7XRzOC6sTUjaJI5S+a230sV69a9m7cTW5gQkXQ=";
  };

  cargoHash = "sha256-vqgrffgMQWzmjIjGswObLPc63hjqXTOwJ3YrA/KyCck=";

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

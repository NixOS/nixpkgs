{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.30";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-t2fpQWXHZzdwkgGk7yhi5IsEDYxeQ5c9gpq78xl9cb0=";
  };

  cargoHash = "sha256-FUODX+alK3lWRPXDxhduNeA9WW44I3fAw33sNCmIUKc=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}

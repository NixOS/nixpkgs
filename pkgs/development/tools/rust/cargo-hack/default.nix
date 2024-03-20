{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.22";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TlTm4pQrviKHusBBYLbpIX1dGcS4dSs1G/TfZT32CvY=";
  };

  cargoHash = "sha256-OFzeD15m6Ie2GrRlItsqDO3QGTBWkcsvSkanbzPdne4=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.27";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TaXVHTUof/T+p0Zxpdf552uVqCr7jzQtNGKLKq7asqI=";
  };

  cargoHash = "sha256-qhD6PLvvfLkVr9rOB90Kw4/jDOw06h7TUe1YCjGad1g=";

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

{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-yLxWV9/e+0IAe4z11i+wwNb6yUehzQwV+EYCe3Z1MOM=";
  };

  cargoSha256 = "sha256-/Za1T+HYI7mmKQHn7qm1d6hqh1qyp9DAOOMi32Tev9g=";

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

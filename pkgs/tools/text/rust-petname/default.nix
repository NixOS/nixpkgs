{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rust-petname";
  version = "1.1.1";

  src = fetchCrate {
    inherit version;
    crateName = "petname";
    sha256 = "sha256-X1p9W+N0Nhh7CSh776ofzHmG0ayi5COLJjBncxmL8CM=";
  };

  cargoSha256 = "sha256-jxN2EKLjf9yKkhZ4wsH72sNdk6UYAcCUrg4+qx75bWs=";

  meta = with lib; {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "petname";
  };
}

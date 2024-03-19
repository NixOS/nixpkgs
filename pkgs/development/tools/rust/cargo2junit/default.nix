{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo2junit";
  version = "0.1.13";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-R3a87nXCnGhdeyR7409hFR5Cj3TFUWqaLNOtlXPsvto=";
  };

  cargoHash = "sha256-u5Pd967qxjqFl9fV/KkClLDBwKql7p66WqbIVBvWKuM=";

  meta = with lib; {
    description = "Converts cargo's json output (from stdin) to JUnit XML (to stdout).";
    mainProgram = "cargo2junit";
    homepage = "https://github.com/johnterickson/cargo2junit";
    license = licenses.mit;
    maintainers = with maintainers; [ alekseysidorov ];
  };
}

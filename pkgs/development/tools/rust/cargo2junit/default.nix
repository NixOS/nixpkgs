{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo2junit";
<<<<<<< HEAD
  version = "0.1.13";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-R3a87nXCnGhdeyR7409hFR5Cj3TFUWqaLNOtlXPsvto=";
  };

  cargoHash = "sha256-u5Pd967qxjqFl9fV/KkClLDBwKql7p66WqbIVBvWKuM=";
=======
  version = "0.1.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wF1vDUVEume6aWzI5smTNlwc9WyZeTtUX416tYYrZPU=";
  };

  cargoSha256 = "sha256-GUCHWV+uPHZwhU4UhdXE2GHpeVnqbUTpfivA9Nh9MoY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Converts cargo's json output (from stdin) to JUnit XML (to stdout).";
    homepage = "https://github.com/johnterickson/cargo2junit";
    license = licenses.mit;
    maintainers = with maintainers; [ alekseysidorov ];
  };
}

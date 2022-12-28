{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo2junit";
  version = "0.1.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wF1vDUVEume6aWzI5smTNlwc9WyZeTtUX416tYYrZPU=";
  };

  cargoSha256 = "sha256-GUCHWV+uPHZwhU4UhdXE2GHpeVnqbUTpfivA9Nh9MoY=";

  meta = with lib; {
    description = "Converts cargo's json output (from stdin) to JUnit XML (to stdout).";
    homepage = "https://github.com/johnterickson/cargo2junit";
    license = licenses.mit;
    maintainers = with maintainers; [ alekseysidorov ];
  };
}

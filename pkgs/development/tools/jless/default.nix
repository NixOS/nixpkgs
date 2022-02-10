{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jless";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "PaulJuliusMartinez";
    repo = "jless";
    rev = "v${version}";
    sha256 = "sha256-gBqyo/N/qF6HCTUrSKNVLiL1fc/JTfip1kNpNCBzRT8=";
  };

  cargoSha256 = "sha256-PbX61RVbrI2kTuyXK+LhQdJDvNo3KjIQH5eBbL6iUBM=";

  meta = with lib; {
    description = "A command-line pager for JSON data";
    homepage = "https://github.com/PaulJuliusMartinez/jless";
    license = licenses.mit;
    maintainers = with maintainers; [ jfchevrette ];
  };
}

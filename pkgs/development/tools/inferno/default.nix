{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.11.15";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fyTsB+1ftol3prNLydT/coLchip1vijmfLLt3/DnBbc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-XBah55xfbWjQrkupebZE2uiveFhh/R0BF1KEKkY5Hx8=";

  # skip flaky tests
  checkFlags = [
    "--skip=flamegraph_base_symbol"
    "--skip=flamegraph_multiple_base_symbol"
  ];

  meta = with lib; {
    description = "A port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = licenses.cddl;
    maintainers = with maintainers; [ figsoda ];
  };
}

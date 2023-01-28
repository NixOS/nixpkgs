{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.11.14";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0H+h4BM4x3vlI6EMeXNzcCQpW2S4czJR2GaviZ0nhEM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-5VQNgZUgakQUczKs7T+c305c3I1DDSaVMO3tFXqIdIc=";

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

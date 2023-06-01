{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.7.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-yo0SgNnwy0LnbIOCLwHUpzjgTZzOoO5GHzKmNVFQOtE=";
  };

  cargoHash = "sha256-3ELBEalMQE+Ozgud+RECl5ClBLy3TqGaEry2OwZ2pGk=";

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

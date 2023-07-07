{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ykAuypWBbZ+53ImzNJGsztLHG8OQLIGBHC6Z3Amu+L0=";
  };

  cargoHash = "sha256-517AXkFqYaHC/FejtxolAQxJVpvcFhmf3Nptzcy9idY=";

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

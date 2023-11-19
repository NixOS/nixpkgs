{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-bd0epx3AciECCYi4OYG2WzTVhZ+JYnf5ebDZoMrPfmo=";
  };

  cargoHash = "sha256-RjjYfdcdJzIxnJFZqx93KADihN5YK+bCuk1QaPhVuGQ=";

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5fPra4kgvykeQnvRtO3enbMIzbh5+nDJ2x0aHYMGiww=";
  };

  cargoHash = "sha256-R7jqFgMj4YjUbEObdRxxvataYMXe9wq8B8k+t7+Dv30=";

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

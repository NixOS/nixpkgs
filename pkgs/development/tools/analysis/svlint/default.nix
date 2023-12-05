{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-PfevtQpbJeo2U/qeYcJP4Et/HUASOZssRu2IXtOLWKw=";
  };

  cargoHash = "sha256-1nPXyFzRmum1CvOFdcqNOQzFVcFFKwPdt2qzXxMssf0=";

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

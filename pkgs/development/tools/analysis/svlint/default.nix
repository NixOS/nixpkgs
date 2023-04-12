{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.7.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-FLyD6fbcBi15gSh4dB9titqrJS3COfJYhxA3uroD24k=";
  };

  cargoHash = "sha256-yD7oQyT7QimUOtaqaUURPP8hV0z6QKBhItk5C+rJjwo=";

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

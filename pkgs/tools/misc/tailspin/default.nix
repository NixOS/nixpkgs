{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = version;
    hash = "sha256-xr9dxq6hUlF3kcXCfmnX2C71NYuGducD0BwbQDnyYJU=";
  };

  cargoHash = "sha256-1jPVCYq8W+LjJCdEimImUcSmd2OvIKMs5n9yl3g7sBM=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
}

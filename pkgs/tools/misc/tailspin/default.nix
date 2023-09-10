{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = "refs/tags/${version}";
    hash = "sha256-mtMUHiuGuzLEJk4S+AnpyYGPn0naIP45R9itzXLhG8g=";
  };

  cargoHash = "sha256-M+TUdKtR8/vpkyJiO17LBPDgXq207pC2cUKE7krarfY=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "spin";
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = version;
    hash = "sha256-Aqm7Nt+rAu8A2216JCuID1eIpWSdKpoKjILYovr7bYw=";
  };

  cargoHash = "sha256-uTUowYoLEywGNzPyxq53Si5GSrh/F9kUFIDjw/wfdAQ=";

  meta = with lib; {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
}

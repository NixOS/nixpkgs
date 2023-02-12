{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "biodiff";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "8051Enthusiast";
    repo = "biodiff";
    rev = "v${version}";
    hash = "sha256-IrIRBozW2nNqt3/643jQ9sHT/YIpYhWeG749bTR4+60=";
  };

  cargoHash = "sha256-EkvZk5l2Jw/6Ejrz4gYFWz9IZLjz0Op/1z3BGBV07dA=";

  meta = with lib; {
    description = "Hex diff viewer using alignment algorithms from biology";
    homepage = "https://github.com/8051Enthusiast/biodiff";
    changelog = "https://github.com/8051Enthusiast/biodiff/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}

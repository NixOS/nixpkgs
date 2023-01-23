{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "biodiff";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "8051Enthusiast";
    repo = "biodiff";
    rev = "v${version}";
    sha256 = "sha256-ZIZ6XpRuqhacpvi1kf7zvMszzbF8IvWrMlxAZnJJSxE=";
  };

  cargoSha256 = "sha256-/LrrHK9j6xg3J56ubM9RdkJeMn4nvpddUGMtHu2s6OE=";

  meta = with lib; {
    description = "Hex diff viewer using alignment algorithms from biology";
    homepage = "https://github.com/8051Enthusiast/biodiff";
    changelog = "https://github.com/8051Enthusiast/biodiff/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}

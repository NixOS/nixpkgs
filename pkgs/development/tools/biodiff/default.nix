{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "biodiff";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "8051Enthusiast";
    repo = "biodiff";
    rev = "v${version}";
    sha256 = "sha256-anGiqTiZVm6q8BII1Ahg2ph7OwX5isCa16orEcf4aFE=";
  };

  cargoSha256 = "sha256-uyATu6M04IRFtzFb2ox0xUYFXjkW+t+71Iy58TuqCko=";

  meta = with lib; {
    description = "Hex diff viewer using alignment algorithms from biology";
    homepage = "https://github.com/8051Enthusiast/biodiff";
    changelog = "https://github.com/8051Enthusiast/biodiff/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}

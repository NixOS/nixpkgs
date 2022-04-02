{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "biodiff";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "8051Enthusiast";
    repo = "biodiff";
    rev = "v${version}";
    sha256 = "sha256-M1hwuIe5+quxcvFAacBkxQMiQyN6lhtWA6hEi5Buoho=";
  };

  cargoSha256 = "sha256-NIt4D2/T7Zl7rgksbQeVo6cNBt6cZkUGTJGztnp6SB0=";

  meta = with lib; {
    description = "Hex diff viewer using alignment algorithms from biology";
    homepage = "https://github.com/8051Enthusiast/biodiff";
    changelog = "https://github.com/8051Enthusiast/biodiff/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}

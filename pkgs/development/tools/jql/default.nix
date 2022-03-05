{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CntAxOsAaKkCvQanLZ4d99VEGrbsVM+IYOhUuimvjlA=";
  };

  cargoSha256 = "sha256-mzHLAmm0wvF35ku+wg6QG/pKwIFjb22fOtBmMhgC0Ik=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

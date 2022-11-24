{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vv22BDFecGEketJb0qQ4+FxSB2BLb9LcnEAqm/BKRxM=";
  };

  cargoSha256 = "sha256-DRrewxKOR0LjpgoN7TWXHWxJxcZ/psjI/lSnyzBXRXM=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

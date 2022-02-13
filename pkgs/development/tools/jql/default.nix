{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mFTJJCoC5nxo5ugJdi+MmssV70yKrQQsH+a+K7hTyS8=";
  };

  cargoSha256 = "sha256-aclfFy2tQL57EaIsg1e30JCF5nX2Cm/MaxeSPtR/Uas=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

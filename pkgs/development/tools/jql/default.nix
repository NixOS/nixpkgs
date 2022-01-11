{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3WLbFKK4gRpPjU/qnfRYGvI2o/ASPph8I2ISEbahpCM=";
  };

  cargoSha256 = "sha256-SYsT4/UaUCgmHJPWfSBf1EBJ7aOiRtWDAFjYEhtI2X4=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

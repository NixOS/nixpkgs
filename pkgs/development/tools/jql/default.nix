{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UfVhkwb89OU7yENcCXM7JfYNsO//des0gsEnvnJGMjA=";
  };

  cargoSha256 = "sha256-kkWslFEdjsWGIrRWylGyTDZnNXcfCVrWT+dVnyvTRqk=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rwnmp2rnzwc7anmk7nr8l4ncza8s1f8sn0r2la4ai2sx1iqn06h";
  };

  cargoSha256 = "1c83mmdxci7l3c6ja5fhk4cak1gcbg0r0nlpbpims5gi16nf99r3";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

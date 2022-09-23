{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bCq8EUczhBx/txafdJvTKqbJoZaGZlrdl87TQt8iMDM=";
  };

  cargoSha256 = "sha256-V+fzGg0MOCG8ikuiFtN3k6825QXRfBRpUKfdTjQVChM=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

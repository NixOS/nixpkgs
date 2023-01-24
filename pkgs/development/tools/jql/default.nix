{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D6Y3I5UPChdLlTZ49iToQpE8CrHh3VjWV6PI7fRhU/A=";
  };

  cargoSha256 = "sha256-GqfQD8NK/HYODEGUmfo+MMVsWg2CabZFLfBTp4UXV2Q=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

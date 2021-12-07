{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gptman";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "cecton";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MWrTwVXlV2B8GzYRgI3np6NqqSGPbRZCKpLU7aC1mX0=";
  };

  cargoSha256 = "sha256-dVvZTYk17fyurtrJxjUgkxU37rxJubiTAQ1AWMnFP4s=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A CLI tool for Linux to copy a partition from one disk to another and more.";
    homepage = "https://github.com/cecton/gptman";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gptman";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "cecton";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hI3F1E1vdbNDEeJ4FrU0EvR0t64svzUIpI6zaf0CquM=";
  };

  cargoSha256 = "sha256-3PRGPZGymccRo9dtQZgMMEL29x+GiUkTzgc8uAB/ocQ=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A CLI tool for Linux to copy a partition from one disk to another and more.";
    homepage = "https://github.com/cecton/gptman";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}

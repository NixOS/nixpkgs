{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "00czgxqvym11fi9z79b7awdcgqwxrpna39giarzvyfdc5rciqk9c";
  };

  cargoSha256 = "1p3y8f8psy1n6m4w3f23xgg7wmalhyf6nc7nbq4iwc1dkcblqq7i";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    homepage = "https://github.com/knurling-rs/flip-link";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}

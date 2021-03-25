{ stdenv, lib, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JwPAwhD+Pkx8Kx24m7z/RbEvDnI2YR8dnTgAV7TMsFE=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
  cargoSha256 = "sha256-lhSSyJxxHc0t43xoDMtr/lSVL0xZl6poPYiyYXNvKKQ=";

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.all;
  };
}

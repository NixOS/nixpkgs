{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gInJS7JpvEbmOuZecB4xjff2d7TnjcVV+8mPOmy5Oyo=";
  };

  cargoHash = "sha256-c5SQysjO821pfGhnyB4aGOZuwrHaN502PfkA1gBPtY4=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "socks" ];

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}

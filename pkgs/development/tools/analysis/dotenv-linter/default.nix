{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenv-linter";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "dotenv-linter";
    repo = "dotenv-linter";
    rev = "v${version}";
    sha256 = "sha256-hhaMI2Z97aT/8FxxtWpn+o3BSo26iyBP+ucpO3x4AbQ=";
  };

  cargoSha256 = "sha256-F9Xyg8/qp0j0+jyd5EVe2idocubzu+Cj6yAwrHuabvM=";

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}

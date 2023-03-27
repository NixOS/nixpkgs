{ lib
, rustPlatform
, fetchFromGitHub
, withSimd ? true
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-ip8+Wy9rmTzFccmjYWb3Nk+gkq3g4e1ty/5+ldIOO10=";
  };

  cargoHash = "sha256-5V0H2FeHI1SByzLsviOR+qHwYhZGiNmMawCTYjk2P24=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "default-optimizations"
  ] ++ lib.optionals withSimd [
    "simd"
  ];

  meta = with lib; {
    description = "Blazing fast Rust JSONPath query engine";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    # build fails on platforms without simd support, even when withSimd = false
    broken = !stdenv.isx86_64;
  };
}

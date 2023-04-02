{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, withSimd ? stdenv.isx86_64
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-kbtw8PhUecxIAxBdklbXtzS3P9o2aw8DCCJaC+vkNT0=";
  };

  cargoHash = "sha256-ZcnMpGgs/3VLdFsPPYzt2EkHNU26dvLnuOHy8OOtp0k=";

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
  };
}

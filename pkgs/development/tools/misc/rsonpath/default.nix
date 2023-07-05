{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, withSimd ? stdenv.isx86_64
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-1fopV2qWbWoCH5cT3s6vLxNTv5LgBm8bug0MJ9p7NmU=";
  };

  cargoHash = "sha256-4IFhUIP5MWNYoHoVi9tjRRzQrsdduiCnmVde5gctdsY=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "default-optimizations"
  ] ++ lib.optionals withSimd [
    "simd"
  ];

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Blazing fast Rust JSONPath query engine";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rq";
  };
}

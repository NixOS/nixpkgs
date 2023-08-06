{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, withSimd ? stdenv.isx86_64
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-RRMT//OnwzoZEsOPZyHfQQbkphopZBI1u8xQe8LsPBo=";
  };

  cargoHash = "sha256-o9L6GUYDDm/WM8iD0k/OGf26w9O8DLH0jMr//ruKnrs=";

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

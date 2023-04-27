{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, withSimd ? stdenv.isx86_64
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-F52IUTfQ2h5z0+WeLNCCmX8vre58ayncW4/lxIwo/T8=";
  };

  cargoHash = "sha256-WY6wXnPh0rgjSkNMWOeOCl//kHlDk0z6Gvnjax33nvE=";

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

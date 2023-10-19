{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, rustPlatform
, rustc
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
    hash = "sha256-4psd9dHqYDqexUYkib057YUEwSQssBz6HF5vv2NV2Fo=";
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-dpLENGY6PFV7WheVcEjuWPLLCMy+voSSCMOs9P9Jjpw=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  meta = with lib; {
    description = "Tool for integrating Rust into an existing CMake project";
    homepage = "https://github.com/corrosion-rs/corrosion";
    changelog = "https://github.com/corrosion-rs/corrosion/blob/${src.rev}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

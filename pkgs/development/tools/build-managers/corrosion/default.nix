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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
    hash = "sha256-/PSOAEtJtn9OykPiN3RhRv59wgQNJ0HoMyYS5RCdSCI=";
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-lJaK+0NmlnTsV3h5Pqpqd8uA3g8PGERWfq2aR7FtYrc=";
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

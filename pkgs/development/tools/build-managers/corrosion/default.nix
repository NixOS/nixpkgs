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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
    hash = "sha256-Bvx4Jvd/l1EHB3eoBEizuT4Lou4Ev+CPA7D7iWIe+No=";
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-0n45edWVSaYQS+S0H4p55d+ZgD6liHn6iBd3qCtjAh8=";
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

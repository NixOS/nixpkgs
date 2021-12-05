{ lib, stdenv, fetchFromGitHub, cmake, rustPlatform, libiconv }:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "unstable-2021-11-23";

  src = fetchFromGitHub {
    owner = "AndrewGaspar";
    repo = "corrosion";
    rev = "f679545a63a8b214a415e086f910126ab66714fa";
    sha256 = "sha256-K+QdhWc5n5mH6yxiQa/v5HsrqnWJ5SM93IprVpyCVO0=";
  };

  patches = [
    # https://github.com/AndrewGaspar/corrosion/issues/84
    ./cmake-install-full-dir.patch
  ];

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    sha256 = "sha256-ZvCRgXv+ASMIL00oc3luegV1qVNDieU9J7mbIhfayGk=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeBuildInputs = [ cmake ]
    ++ (with rustPlatform; [ cargoSetupHook rust.cargo rust.rustc ]);

  cmakeFlags = [
    "-DRust_CARGO=${rustPlatform.rust.cargo}/bin/cargo"

    # tests cannot find cargo because Rust_CARGO is unset before tests
    "-DCORROSION_BUILD_TESTS=OFF"
  ];

  meta = with lib; {
    description = "Tool for integrating Rust into an existing CMake project";
    homepage = "https://github.com/AndrewGaspar/corrosion";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

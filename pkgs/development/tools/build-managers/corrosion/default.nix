{ lib
, stdenv
, fetchFromGitHub
, cmake
, rustPlatform
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "unstable-2021-02-23";

  src = fetchFromGitHub {
    owner = "AndrewGaspar";
    repo = "corrosion";
    rev = "e6c35c7e55a59c8223577b5abc4d253b4a82898b";
    sha256 = "0vq6g3ggnqiln0q8gsr8rr5rrdgpfcgfly79jwcygxrviw37m44d";
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
    sha256 = "1fsq8zzzq28fj2fh92wmg8kmdj4y10mcpdmlgxsygy5lbh4xs13f";
  };

  nativeBuildInputs = [
    cmake
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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

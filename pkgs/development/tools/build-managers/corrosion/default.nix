{ lib
, stdenv
, fetchFromGitHub
, cmake
, rustPlatform
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "unstable-2022-01-03";

  src = fetchFromGitHub {
    owner = "AndrewGaspar";
    repo = "corrosion";
    rev = "ba253b381e99bd87b514db9cee299b849c7625b5";
    hash = "sha256-r1chLXvWbHtUYSRJis8RNvjDdWERSkqeM4ik30vlfHQ=";
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-xUDmUj73ja8feEh0yyjgkjm7alPaYxucG6sL59mSECg=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

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

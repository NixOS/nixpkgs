{ lib
, stdenv
, fetchFromGitHub
, cmake
, rustPlatform
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
    hash = "sha256-nJ4ercNykECDBqecuL8cdCl4DHgbgIUmbiFBG/jiOaA=";
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-4JVbHYlMOKztWPYW7tXQdvdNh/ygfpi0CY6Ly93VxsI=";
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
    homepage = "https://github.com/corrosion-rs/corrosion";
    changelog = "https://github.com/corrosion-rs/corrosion/blob/${src.rev}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

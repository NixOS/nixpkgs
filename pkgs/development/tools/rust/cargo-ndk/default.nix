{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  CoreGraphics,
  Foundation,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "3.5.5";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2nL+NE4ntZbm2DdPZEoJLDeMAxaPXgrSSIvwAThlLlA=";
  };

  cargoHash = "sha256-Fa1pkHdjngJx7FwfvSQ76D61NPYC88jXqYnjWx6K2f8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreGraphics
    Foundation
  ];

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    mainProgram = "cargo-ndk";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ mglolenstine ];
  };
}

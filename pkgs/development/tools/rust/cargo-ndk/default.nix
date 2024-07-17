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
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-piNKtmDssDeB+DznLl0uufT5BFiVCMmYGuRmBUr5QWQ=";
  };

  cargoHash = "sha256-sIKan8LnGv4sGVrGOUOKSD3R4fNRu5yBFATm5MWDTSU=";

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

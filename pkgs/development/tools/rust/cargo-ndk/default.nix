{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreGraphics
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rpEBxoXm77UuK7jiaf90yxVnmJay6ptkRk5KUEBoSvk=";
  };

  cargoHash = "sha256-XRT4U6zkmXzNnPnnHWrGlQWVV3W09UXQ0McksIFKgyE=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreGraphics
    Foundation
  ];

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ mglolenstine ];
  };
}


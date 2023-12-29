{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreGraphics
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PdRiiGRYdbnViK34PnYoLFteipoK2arw79IVOQnJKNE=";
  };

  cargoHash = "sha256-6rQwyogm62xx9JmDWfRtCpF1Rqjtt5SDYUdtZBfryuw=";

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


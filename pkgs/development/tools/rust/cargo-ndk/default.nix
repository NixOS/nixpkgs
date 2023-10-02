{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreGraphics
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jMhDKMFJVz/PdMnSrA+moknXPfwFhPj/fggHDAUCsNY=";
  };

  cargoHash = "sha256-IUMS0oCucYeBSfjxIYl0hhJw2GIpSgh+Vm1iUQ+Jceo=";

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


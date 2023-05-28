{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreGraphics
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L7HZzudu26Vyz1qm2soqGlZf8sBJKcx1BoBf8zC0ee4=";
  };

  cargoHash = "sha256-RMP1Nz2uWVIOxSlsjTR6QsVy6Heu9dXhrBBI5xGMbtY=";

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


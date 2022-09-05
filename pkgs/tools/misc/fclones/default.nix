{ lib
, stdenv
, fetchFromGitHub
, libiconv
, rustPlatform
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cP17WnQsP2S78O9MfmpivibvN1vYMeSNBSrrOENHUiE=";
  };

  cargoSha256 = "sha256-P1T9AAeEmCOiM74RPE/3Lz/XGAj150xTF3egjDv+zvc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    libiconv
  ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins msfjarvis ];
  };
}

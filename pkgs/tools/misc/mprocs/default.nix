{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IzaXcEm4eUpLWsn59ZSiIJ0mCegLhBiA3ONKI1Djemk=";
  };

  cargoSha256 = "sha256-nTFCFmmS3IIm+D2PjvDxUKQGTn2h0ajXtxLuosa9rRY=";

  meta = with lib; {
    description = "A TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage thehedgeh0g ];
  };
}

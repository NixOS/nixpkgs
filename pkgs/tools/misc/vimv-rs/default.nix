{ lib, rustPlatform, fetchCrate, stdenv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
  version = "1.7.7";

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
    sha256 = "sha256-Y8xFoI/1zpaeT9jMuOME/g2vTLenhNSwGepncc1Ji+0=";
  };

  cargoHash = "sha256-yJHOeIjbWQTxLkkVv+YALrAhP5HBZpmbPDiLd+/bWZA=";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}

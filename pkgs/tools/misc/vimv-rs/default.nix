{ lib, rustPlatform, fetchCrate, stdenv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
  version = "3.0.0";

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
    hash = "sha256-DpdozP/xaMoRAl8YMj5BmhNedGFhVzscM/eFOcVt+Lk=";
  };

  cargoHash = "sha256-zKJ8A36/ibAiznm3bK2JSHVRItIAqQ4YFDxvjcZLn3g=";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}

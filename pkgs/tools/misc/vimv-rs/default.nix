{ lib, rustPlatform, fetchCrate, stdenv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
  version = "1.7.5";

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
    sha256 = "sha256-VOHQLdwJ6c8KB/IjMDZe9/pNHmLuouNggIK8uJPu+NQ=";
  };

  cargoHash = "sha256-qXT44h4f4Zw1bi/gblczxehA6hqLLjQBpSwVpYd0PE4=";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}

{ lib, rustPlatform, fetchCrate, stdenv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
  version = "1.8.0";

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
    hash = "sha256-HEWhWPLFIEo+sOz0pbvhoFRNhYh/x0ohqDs48sHgHHk=";
  };

  cargoHash = "sha256-ghO8HrHk5rjUiNbutWnrQLAd8vtVKV6pK12XZuSudSs=";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}

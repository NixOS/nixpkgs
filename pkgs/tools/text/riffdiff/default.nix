{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-Vbze2WSrZOboLFcsnRYbfsWz6gbMEszDWEMQUNZAzLY=";
  };

  cargoHash = "sha256-/R2RSsNRpCI/LTXlF0UtdIjWrBDJaEOASTeAtyNwS0M=";

  meta = with lib; {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}

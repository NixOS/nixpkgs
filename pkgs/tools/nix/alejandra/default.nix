{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    hash = "sha256-jj66PRqXASDNzdidkdfF2ezWM45Pw9Z+G4YNe8HRPhU=";
  };

  cargoSha256 = "sha256-701lWa/2u10vCSRplL1ebYz29DxjpHY0SqjSWme1X1U=";

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}

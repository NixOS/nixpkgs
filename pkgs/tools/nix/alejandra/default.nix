{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "unstable-2022-02-10";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = "0c095ed50d3bbfd50f9f97832f7ac8092a8c1289";
    hash = "sha256-eIPyrL8C3qQbEahoryS70cJ4FbXDdPQuWaM2jD2BbI0=";
  };

  cargoSha256 = "sha256-DyE0TV/dHbDFkFvF9h0+qi+p2XD8lDZzsUByfOt/UjA=";

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}

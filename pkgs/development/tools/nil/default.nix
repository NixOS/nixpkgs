{ lib, rustPlatform, fetchFromGitHub }:

let
  date = "2022-09-19";
in

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "unstable-${date}";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = date;
    sha256 = "sha256-WdBRfp0shz6Xhwx0fEUQwROK52XNDTkmhC2xkdT+INA=";
  };

  cargoSha256 = "sha256-J1CRe5xPl428mwOO4kDxLyPBc0mtzl3iU4mUqW5d4+E=";

  CFG_DATE = date;

  meta = with lib; {
    description = "A language server for Nix Expression Language";
    homepage = "https://github.com/oxalica/nil";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}

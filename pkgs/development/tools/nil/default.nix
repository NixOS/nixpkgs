{ lib, rustPlatform, fetchFromGitHub }:

let
  date = "2022-09-10";
in

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "unstable-${date}";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = date;
    sha256 = "sha256-yqg46An5TPl6wsv5xflK4T90fTho4KXIILoV71jSl28=";
  };

  cargoSha256 = "sha256-MabVHbNGWpeUztwedXRXHBfgEostxk0aWpGCHlpnhJo=";

  CFG_DATE = date;

  meta = with lib; {
    description = "A language server for Nix Expression Language";
    homepage = "https://github.com/oxalica/nil";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}

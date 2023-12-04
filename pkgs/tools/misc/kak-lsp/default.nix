{ stdenv, lib, fetchFromGitHub, rustPlatform, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DpWYZa6Oe+Lkzga7Fol/8bTujb58wTFDpNJTaDEWBx8=";
  };

  cargoHash = "sha256-+3cpAL+8X8L833kmZapUoGSwHOj+hnDN6oDNJZ6y24Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
    mainProgram = "kak-lsp";
  };
}

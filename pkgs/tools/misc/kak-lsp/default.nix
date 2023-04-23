{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "14.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5eGp11qPLT1fen39bZmICReK2Ly8Kg9Y3g30ZV0gk04=";
  };

  cargoSha256 = "sha256-+Sj+QSSXJAgGulMLRCWLgddVG8sIiHaB1xWPojVCgas=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

{ stdenv, lib, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "198y2k3vi8dh9kfqgl7vpgkxvjlfvryi9c8hmb43m0lpwsja0010";
  };

  cargoSha256 = "0sv1a2k5rcf4hl1w50mh041r3w3nir6avyl6xa3rlcc7cy19q21y";

  buildInputs = lib.optional stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

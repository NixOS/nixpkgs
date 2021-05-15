{ stdenv, lib, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1wfv2fy5ga6kc51zka3pak0hq97csm2l11bz74w3n1hrf5q9nnf8";
  };

  cargoSha256 = "0g67s6n45rxvv1q5s7x5ajh5n16p68bhlsrsjp46qamrraz63d68";

  buildInputs = lib.optional stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/ul/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

{ stdenv, lib, darwin, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "ul";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nka51szivwhlfkimjiyzj67nxh75m784c28ass6ihlfax631w9m";
  };

  cargoSha256 = "15bdf4imp091bmcs5xn6n12nqsrgqkdwqsms0g12gs6c8fhxw9zb";

  buildInputs = lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/ul/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

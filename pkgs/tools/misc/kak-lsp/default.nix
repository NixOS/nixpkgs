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

  cargoSha256 = "174qy50m9487vv151vm8q6sby79dq3gbqjbz6h4326jwsc9wwi8c";

  buildInputs = lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/ul/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.all;
  };
}

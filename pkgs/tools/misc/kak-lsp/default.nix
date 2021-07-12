{ stdenv, lib, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SmK4G9AoKGqKGbXucn5AO5DTOeVNq3gCBGvDTIJQgRU=";
  };

  cargoSha256 = "sha256-iY5xT8e/gRN/mBT9v5LhMcl9g1/SyrH/glPBP+toZ9o=";

  buildInputs = lib.optional stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/ul/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

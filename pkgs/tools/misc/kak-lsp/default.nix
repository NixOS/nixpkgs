{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i+oi5lCNIWPVPP5o7IamSVPvCB/FhO/v08zOipmaE+c=";
  };

  cargoSha256 = "sha256-acxdGhExfE4g1YNp3bRQlEuUqz79y1IhDnqTaYh/nxc=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

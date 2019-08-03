{ stdenv, lib, darwin, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "ul";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bazbz1g5iqxlwybn5whidvavglvgdl9yp9qswgsk1jrjmcr5klx";
  };

  cargoSha256 = "0w0mnh8fnl8zi9n0fxzqaqbvmfagf3ay5v2na3laxb72jm76hrwa";

  buildInputs = lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = https://github.com/ul/kak-lsp;
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.all;
  };
}

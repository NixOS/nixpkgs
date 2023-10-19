{ stdenv, lib, fetchFromGitHub, rustPlatform, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "14.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U4eqIzvYzUfwprVpPHV/OFPKiBXK4/5z2p8kknX2iME=";
  };

  cargoSha256 = "sha256-g63Kfi4xJZO/+fq6eK2iB1dUGoSGWIIRaJr8BWO/txM=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

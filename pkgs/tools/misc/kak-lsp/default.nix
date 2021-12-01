{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rSUXMQF4V+ToYw3RIfEZd2AfAiHoRPDC3DZBAg2zeKo=";
  };

  cargoSha256 = "sha256-vcq+WVHmGFrZFLzNWyHU7qN6cDSKP9pAzxZNs2+8jR8=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

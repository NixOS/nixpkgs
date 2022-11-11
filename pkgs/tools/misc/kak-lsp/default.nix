{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RTz8BdbEiAY6wyIS18LZRQQ1DQzIRz2Bk7bOeMf7sT8=";
  };

  cargoSha256 = "sha256-fHVKm4DWhkwbbRGLvMfoEjJfM6VF7RW6x75NR7aNs7o=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}

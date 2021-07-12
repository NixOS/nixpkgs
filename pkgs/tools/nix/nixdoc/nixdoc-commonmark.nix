{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "453159e97d12849da83ce8d4d385067983f8c5cc";
    hash = "sha256-m+Du8n3kDoez7xbTV6FGF+bgJ2tSTGg2DclYKlAyGxA=";
  };

  buildInputs = lib.optional stdenv.isDarwin [ darwin.Security ];

  cargoSha256 = "sha256-ZQPtKQ8tScGzgaXTL24/rPSNr2cW3zxlxXxJWTN6Zts=";

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage = "https://github.com/nix-community/nixdoc";
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.tazjin ];
    platforms = platforms.unix;
  };
}

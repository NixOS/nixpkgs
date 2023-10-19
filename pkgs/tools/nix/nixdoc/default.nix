{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-cEMehtxkqXAar/fDy3CnzsDEAuC1ABBaYqzqVBGnTrs=";
  };

  cargoHash = "sha256-QFDHIqXyTWTdqNrLcwWw3plX6EDH/k043nay5opjtws=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = [ maintainers.asymmetric ];
    platforms   = platforms.unix;
  };
}

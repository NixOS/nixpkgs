{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-g1PBPpvK3kg0bJEDXsifVgcl3+v54q08Ae3nZ4cJ+Xs=";
  };

  cargoHash = "sha256-E5SJfwGfy1DcLC0cF/5FTbVEJs/WYb2KO+OdOo2fgQk=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = with maintainers; [
      infinisil
      asymmetric
    ];
    platforms   = platforms.unix;
  };
}

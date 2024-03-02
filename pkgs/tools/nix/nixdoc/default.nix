{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-PnvVGw0DMBg/l7+QpcXW5AFfR6MeXBiUYdVAZuue1jA=";
  };

  cargoHash = "sha256-qLTUyhoEVtjgh+ilEv+pQLXLYWlW9gVsCiA5rPfymZY=";

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

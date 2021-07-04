{ lib, rustPlatform, fetchFromGitHub, boost, nix, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "nix-doc";
  version = "0.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "lf-";
    repo = "nix-doc";
    sha256 = "1s0nlbn5fcgqfns8gpx3i87k5qivd8ar59rklvd7fbn6ckrmzi6m";
  };

  doCheck = true;
  buildInputs = [ boost nix ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "0xmw3fyic0fcg7a6z8dr3lv367bxqdhdrlrl2hhlz59xg5kq8b3f";

  meta = with lib; {
    description = "An interactive Nix documentation tool";
    longDescription = "An interactive Nix documentation tool providing a CLI for function search, a Nix plugin for docs in the REPL, and a ctags implementation for Nix script";
    homepage = "https://github.com/lf-/nix-doc";
    license = licenses.lgpl3;
    maintainers = [ maintainers.lf- ];
    platforms = platforms.unix;
  };
}

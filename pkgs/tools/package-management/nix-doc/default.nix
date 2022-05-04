{ lib, rustPlatform, fetchFromGitHub, boost, nix, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "nix-doc";
  version = "0.5.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "lf-";
    repo = "nix-doc";
    sha256 = "sha256-H8FNOOjHMUW2wIUfoDhS3eH2AgxxD0LAuX4J9SJyJhg=";
  };

  doCheck = true;
  buildInputs = [ boost nix ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-BTMFoZ8HqbgUXkVyydOkcQZ10TLE8KsGRdt+xhBKJVc=";

  meta = with lib; {
    description = "An interactive Nix documentation tool";
    longDescription = "An interactive Nix documentation tool providing a CLI for function search, a Nix plugin for docs in the REPL, and a ctags implementation for Nix script";
    homepage = "https://github.com/lf-/nix-doc";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.lf- ];
    platforms = platforms.unix;
  };
}

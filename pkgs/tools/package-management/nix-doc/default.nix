{ lib, stdenv, rustPlatform, fetchFromGitHub, boost, nix, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "nix-doc";
  version = "0.3.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "lf-";
    repo = "nix-doc";
    sha256 = "0vd7159y5w8jjgaw51kfr3z3r50299gvw7vjchpqx3nwmdink8bh";
  };

  doCheck = true;
  buildInputs = [ boost nix ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "1xz3qngs8p0s62dq4d46c01z3k1vvgg856767g56b13c38pzfh28";

  meta = with lib; {
    description = "An interactive Nix documentation tool";
    longDescription = "An interactive Nix documentation tool providing a CLI for function search and a Nix plugin for docs in the REPL";
    homepage = "https://github.com/lf-/nix-doc";
    license = licenses.lgpl3;
    maintainers = [ maintainers.lf- ];
    platforms = platforms.unix;
  };
}

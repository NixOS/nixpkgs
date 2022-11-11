{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "lzanini";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5PzXX7icRxcHpzjp3x/9ssn2o0444uHrzBn1Ds1DEPM=";
  };

  cargoPatches = [
    # Remove when https://github.com/lzanini/mdbook-katex/pull/35 is in a new release.
    ./update-mdbook-for-rust-1.64.patch
  ];

  cargoHash = "sha256-lrEirKkGf9/8yLyLSON54UaeQ3Xtl7g7ezUc7e1KVHw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

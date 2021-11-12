{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "lzanini";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5PzXX7icRxcHpzjp3x/9ssn2o0444uHrzBn1Ds1DEPM=";
  };

  cargoSha256 = "sha256-tqdpIBlKiyYSWFPYTnzVeDML2GM+mukbOHS3sNYUgdc=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

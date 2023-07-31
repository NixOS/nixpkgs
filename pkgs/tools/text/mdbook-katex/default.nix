{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZiMMO3v//re6rCwDojJqaXChKL4wTK1fKVdQ8plHv9Q=";
  };

  cargoHash = "sha256-FEyUWR5WcKZsGTFAnvysYReH1wOrKYoKQ0wlrPaW4ok=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

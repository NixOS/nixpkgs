{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-hrST3bfODCqsGUsO2sMk70KICMZCe+J1pDeO3TTcsaU=";
  };

  cargoHash = "sha256-qoeHdgR67aZvmM6l8IPLcR2sHW2v5sL4k7ymxHPdlis=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

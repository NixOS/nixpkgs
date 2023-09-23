{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yOZTvCuxb2dqH06xgvS2+Vz9Vev0mI/ZEzdL8JPMu8s=";
  };

  cargoHash = "sha256-zjBPOEv8jCn48QbK512O3PfLLeozr8ZHkZcfRQSQnvY=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

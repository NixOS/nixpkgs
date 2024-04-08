{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-kQZZpVF265QmEle2HPSSHOaZFl/z/1Uvx0Fs+21HnLI=";
  };

  cargoHash = "sha256-/IBJWGi1jYwFHdYZv8/AHiBP9oLtOVW0sLJVOQJutXA=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

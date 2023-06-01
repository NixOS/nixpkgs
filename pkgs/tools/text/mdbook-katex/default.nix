{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-QfimccchYkOfGxYXZQ4iR3tGDfyj3ZhvWCuVteLncpE=";
  };

  cargoHash = "sha256-bER9N9qkoxmIaM4nZNJe8UarMFb+WeHIjJqL/EH/C/U=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PbnoTqVgo3qypnC1GT4pmvAmYbWV0F+FvEiaL3D9MmE=";
  };

  cargoHash = "sha256-H+yb6h3ipXZwD96GxI8Ep0PMxkd7EfAyVZvi25/U3YA=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

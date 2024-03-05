{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yq5cKb9Kzto+vM1/FEZhxB/+sHY7H0S1knSEtVklJvk=";
  };

  cargoHash = "sha256-GtQoWNOs1SU8yoMyxh81weqMkhhRC09tNuTBNPoPj7U=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

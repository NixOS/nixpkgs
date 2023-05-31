{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5Xhc6tG4mi+225a8unfQ5Ualqql8RiKT3HndTY2x0gE=";
  };

  cargoHash = "sha256-esQ8MiwWk1yYN5jwPVBEmKsjd4RDRO30N8JjTnsgCMI=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YFrl0YR/+lDJW8GjLF0wk0D6Bx9zUxAoAXd9twaxrmM=";
  };

  cargoHash = "sha256-wBaek9AQKwPsg9TzBmS0yBtn1G0KCnmxfmGCGCFNWxc=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

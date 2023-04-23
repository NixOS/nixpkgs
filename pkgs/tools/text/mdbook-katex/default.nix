{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.15";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7PB6aYi8+cgoiN1zVBYWVIJgLlZFN8dGcY970iwPKWE=";
  };

  cargoHash = "sha256-JRRSeUGFDFSiaPxqegpQIGW8Q6Gs3GFHUx4+1jscZrU=";

  OPENSSL_DIR = "${lib.getDev openssl}";
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

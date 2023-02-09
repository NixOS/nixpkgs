{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DZ+5rYRHS5m4Alw6/Ak98UH2FD3EPBGDtB+vD0v8EMk=";
  };

  cargoHash = "sha256-i6u7kriLFgMSJDfA6JRjTLc3Oi8GfHjE7wEJbTLnMN8=";

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

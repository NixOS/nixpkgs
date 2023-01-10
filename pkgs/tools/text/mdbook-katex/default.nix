{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-s3ZR1fQ5x6FiHzoiDCqZahQCjhtuOoeDM32w/16DEmk=";
  };

  cargoHash = "sha256-/fO+ozw6dg8TeIYQ3R7LWT+acDToNcGFvceV8YojVCw=";

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

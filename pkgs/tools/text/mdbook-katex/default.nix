{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-QFlYZFPBV7kKeSG2znXsicMMsiULanf1v2oflrtSJvM=";
  };

  cargoHash = "sha256-E+lLx8q3uaIZP1/QQ+RzJ0jt1sbi8Je3pTfWyk/O4T8=";

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

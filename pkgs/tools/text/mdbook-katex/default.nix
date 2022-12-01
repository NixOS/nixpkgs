{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.2.17";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-rJzZVZn8CJOIcSVLCLv6tWox0MRdxNBMUKo1fij1ogc=";
  };

  cargoHash = "sha256-aSFXTeP5wDshdrrJ+eJCTmLuTlxCuM+5irUr0iW4tAY=";

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

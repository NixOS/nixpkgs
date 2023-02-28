{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LeI46x5M2ZYUOIxuj9bCNwwucRLvoOkdRhsowmVxS68=";
  };

  cargoHash = "sha256-pEwPnE2EpS+0bw3/SSKOCy8R5xUiG6mBMoup6wbrf+0=";

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

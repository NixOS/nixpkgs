{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Bc9nUY2XyNlgOI436omg885Qm0BtqcrFsJz6qr2Zhys=";
  };

  cargoHash = "sha256-pH5ZN6bTjstrSTv0hdOoyWAdRLRjALarML3ZVoYvGRI=";

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

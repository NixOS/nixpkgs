{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oGefjf4URmE0i6mOjpZfBcSh280O+IvrAhu3vFAyntQ=";
  };

  cargoHash = "sha256-tkMdxkJcvmDSH2ree1nol1JlKKhI5G4x9x5Hs0peKI8=";

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

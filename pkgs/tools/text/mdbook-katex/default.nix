{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-K96zIjWIHQN20LmmiqGEBv5/gi0CzHQt/FgRC00Z/lE=";
  };

  cargoHash = "sha256-KIPP2tT9wrTrIy6YLgSCc4hgKJXT0ZJjp/ftSxs2row=";

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

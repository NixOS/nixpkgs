{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.2.21";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cJRO/HHxujSL5YTM4e+HMRsItlEe1OYn8rSqnwcqbgU=";
  };

  cargoHash = "sha256-FPoSye+wD/MPR5fCrQ212W4iYoJLWOFXgeStcg0GEHw=";

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

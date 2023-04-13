{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.11";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TeMB0+XjFSVg0kEV+uN7o0gc3PapkOAe+AI5AfcwczE=";
  };

  cargoHash = "sha256-eu2B+YtSTwehU0bIRI1favDyLdth845xfi+y+jP40Hc=";

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

{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.3.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FsKHGw/6n/8eCJh1XatNsw3iCzD+siHdJ3i0dNKD5Go=";
  };

  cargoHash = "sha256-nyLWbwruzQeyPGkVuMiRCTHtFE+E9nQ57ZMXxqIcLxE=";

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

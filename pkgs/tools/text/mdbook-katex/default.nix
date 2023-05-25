{ lib, stdenv, fetchCrate, rustPlatform, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aEtmHihncs+Z+VRtUVsiRLK72bDWJQNjy/Q5xBvM1d0=";
  };

  cargoHash = "sha256-L5bdR1khL3AHRNtFhy1GWRqMxdpNxrYGX3TELCUB4mQ=";

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

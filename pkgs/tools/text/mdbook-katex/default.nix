{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IecCEXoWkjCgIHlhmtF2H+FM/0B8yK4XmHuBHv/yGk8=";
  };

  cargoHash = "sha256-vHbTL62Z4UdU77VePN2HSRzS9amn33smw1Yy6I2Btcc=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

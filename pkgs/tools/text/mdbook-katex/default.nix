{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6gZTJrjr3cO7f6XBrQrBKe62UsnPxGo1eXX/+ICdJfk=";
  };

  cargoHash = "sha256-KHC37LNnc789anxJBADgj97tw5TwR/5ksxP3X/9pHlo=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

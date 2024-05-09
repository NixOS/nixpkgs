{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-E/MVijHbd0VgBBHFGjizEBpHeNi52ina8k6dO+BOH/U=";
  };

  cargoHash = "sha256-ZEN7tAB9+SX9hXvu4VHab8DwRp112hKIY/6yA97T+fw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault matthiasbeyer ];
  };
}

{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OTMPf/ZlUtqKz8Lb0uFOhad33N6SaCIZ86I2ajZ19fU=";
  };

  cargoHash = "sha256-U8uDcNkEyz7zAqCTthY5SVGshsJRKRaoBLOpBpQ9sho=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
}

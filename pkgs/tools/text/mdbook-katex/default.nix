{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-F+yNfXBTAg9S6R85bGStumr1OXdWN3o95TxC0qgUeME=";
  };

  cargoHash = "sha256-01lr6ZS+7MmgKmuP+xEX7j1x2qDofmzeevUqY/UqRUw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

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

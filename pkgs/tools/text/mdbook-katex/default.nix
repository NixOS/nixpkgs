{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.8.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mVgI2lvT4w5+Tpq3Sx7j86LHFnuwI4bAAAqrUkiF1B4=";
  };

  cargoHash = "sha256-ps31HGsAqWJBTP7HNLjfTz610ihDlvfAvlRHqZR01No=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
}

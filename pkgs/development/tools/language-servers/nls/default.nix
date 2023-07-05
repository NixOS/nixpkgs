{ lib
, rustPlatform
, nickel
}:

rustPlatform.buildRustPackage {
  pname = "nls";

  inherit (nickel) src version;

  cargoHash = "sha256-tahSuSc16oUUjeBBAnTDAiSaLr0zMKgN/XvypXqvvxw=";

  cargoBuildFlags = [ "-p nickel-lang-lsp" ];

  meta = {
    inherit (nickel.meta) homepage changelog license maintainers;
    description = "A language server for the Nickel programming language";
    longDescription = ''
      The Nickel Language Server (NLS) is a language server for the Nickel
      programming language. NLS offers error messages, type hints, and
      auto-completion right in your favorite LSP-enabled editor.
    '';
  };
}

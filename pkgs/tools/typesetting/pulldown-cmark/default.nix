{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.9.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5rCoFI+QWQVxF4YUzwP7jQytiIzTXtlOr3AJzHMdtR8=";
  };

  cargoHash = "sha256-it18jXKqUE43A6KAsx+BFc7YwufXjk1FJ0u8D2EolHQ=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}

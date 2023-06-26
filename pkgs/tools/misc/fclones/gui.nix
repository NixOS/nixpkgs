{ lib
, rustPlatform
, fetchCrate
, pkg-config
, wrapGAppsHook4
, gdk-pixbuf
, gtk4
, libadwaita
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones-gui";
  version = "0.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SQJ6CZlvu4V9Rs+rhH4jMf0AVWs71KvRUnUxGPlgj80=";
  };

  cargoHash = "sha256-8WLYbEbPrR8c0y+Uaxo6YGiFRt7FLHZM+1O/UZq0c7g=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libadwaita
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  meta = with lib; {
    description = "Interactive duplicate file remover";
    homepage = "https://github.com/pkolaczk/fclones/tree/main/fclones-gui";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

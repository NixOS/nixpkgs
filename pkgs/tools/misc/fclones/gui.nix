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
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rMeXUNpoEzqsDmlTmnHsFkas3zFgdCH0WSeP83RtT+c=";
  };

  cargoHash = "sha256-2oeyTMYg0PyTpSMLaub3nZGeoK5U6BlC8OReBwRi3DA=";

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

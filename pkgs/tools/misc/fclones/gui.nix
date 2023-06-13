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
  version = "0.1.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ge2l414kYHK3y4V837GTQ5sSxVRlU8ZYyGdBj4+vUL8=";
  };

  cargoHash = "sha256-rDAUA75KCWlhf13bCucV5w9WAJ+Uw+s8sUCCeWBYJeA=";

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

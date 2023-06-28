{ lib
, rustPlatform
, fetchFromGitHub
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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = "fclones-gui";
    rev = "v${version}";
    hash = "sha256-zJ5TqFmvUL1nKR8E+jGR4K6OGHJ4ckRky+bdKW0T30s=";
  };

  cargoHash = "sha256-QT4ZxjarPkEqJLKPsGAaMIaSUmKWZ1xtxWMe2uXaUek=";

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
    homepage = "https://github.com/pkolaczk/fclones-gui";
    changelog = "https://github.com/pkolaczk/fclones-gui/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

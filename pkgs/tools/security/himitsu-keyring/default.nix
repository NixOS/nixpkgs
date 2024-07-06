{ lib
, stdenv
, fetchFromSourcehut
, desktop-file-utils
, glib
, gobject-introspection
, gtk3
, gtk-layer-shell
, libhandy
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "himitsu-keyring";
  version = "0.1.0";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~martijnbraam";
    repo = "keyring";
    rev = "c4706fff5ccc72cd9e524b8cf51fd048f67ee415";
    hash = "sha256-csNCfy2fPOO2RAOHHGiBfI+HuG2BsbLzbterE63TVqs=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gobject-introspection
    gtk3
    gtk-layer-shell
    libhandy
    (python3.withPackages (pp: with pp; [
      pygobject3
    ]))
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~martijnbraam/keyring/";
    description = "Himitsu keystore frontend";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    platforms = platforms.linux;
  };
}

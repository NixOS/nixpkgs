{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, gtk-layer-shell
, gtk3
, json-glib
, libgee
, libhandy
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "swaync";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = "v${version}";
    hash = "sha256-gXo/V2FHkHZBRmaimqJCzi0BqS4tP9IniIlubBmK5u0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    json-glib
    libgee
    libhandy
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"
    )
  '';

  meta = with lib; {
    description = "A simple notification daemon with a GTK gui for notifications and the control center";
    homepage = "https://github.com/ErikReider/SwayNotificationCenter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}

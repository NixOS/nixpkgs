{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, wayland
, wayland-protocols
, libwpe
, libwpe-fdo
, glib-networking
, webkitgtk
, makeWrapper
, wrapGAppsHook
, gnome
, gdk-pixbuf
}:

stdenv.mkDerivation rec {
  pname = "cog";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "igalia";
    repo = "cog";
    rev = version;
    sha256 = "sha256-Ss1wZREE56BzLf/2ec7Qv/tc7HiMfXJKaNpP7WJa9xg=";
  };

  buildInputs = [
    wayland-protocols
    wayland
    libwpe
    libwpe-fdo
    webkitgtk
    glib-networking
    gdk-pixbuf
    gnome.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    wayland
    makeWrapper
    wrapGAppsHook
  ];

  depsBuildsBuild = [
    pkg-config
  ];

  meta = with lib; {
    description = "A small single “window” launcher for the WebKit WPE port";
    license = licenses.mit;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.linux;
  };
}

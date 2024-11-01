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
, webkitgtk_4_0
, makeWrapper
, wrapGAppsHook3
, adwaita-icon-theme
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
    webkitgtk_4_0
    glib-networking
    gdk-pixbuf
    adwaita-icon-theme
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    wayland
    makeWrapper
    wrapGAppsHook3
  ];

  depsBuildsBuild = [
    pkg-config
  ];

  meta = with lib; {
    description = "Small single “window” launcher for the WebKit WPE port";
    homepage = "https://github.com/Igalia/cog";
    mainProgram = "cog";
    license = licenses.mit;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.linux;
  };
}

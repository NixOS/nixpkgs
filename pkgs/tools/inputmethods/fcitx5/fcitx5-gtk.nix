{ lib, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, gobject-introspection
, gtk2
, gtk3
, gtk4
, pcre
, libuuid
, libselinux
, libsepol
, libthai
, libdatrie
, libXdmcp
, libxkbcommon
, epoxy
, dbus
, at-spi2-core
, libXtst
, withGTK2 ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-gtk";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-gtk";
    rev = version;
    sha256 = "sha256-+BzXbZyzC3fvLqysufblk0zK9fAg5jslVdm/v3jz4B4=";
  };

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION_GIRDIR=share/gir-1.0"
    "-DGOBJECT_INTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ] ++ lib.optional (! withGTK2) "-DENABLE_GTK2_IM_MODULE=off";

  buildInputs = [
    gtk3
    gtk4
    gobject-introspection
    fcitx5
    pcre
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    libXdmcp
    libxkbcommon
    epoxy
    dbus
    at-spi2-core
    libXtst
  ] ++ lib.optional withGTK2 gtk2;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Fcitx5 gtk im module and glib based dbus client library";
    homepage = "https://github.com/fcitx/fcitx5-gtk";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, gobject-introspection
, gtk2
, gtk3
, gtk4
, glib
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
, fmt
, withGTK2 ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-gtk";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-gtk";
    rev = version;
    sha256 = "sha256-rP0L7D7VdbNSmwQhnS5tvQT4FS3qpOnuBTQQp82O5fE=";
  };

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION_GIRDIR=share/gir-1.0"
    "-DGOBJECT_INTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
    "-DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES=${lib.getDev glib}/include/gio-unix-2.0"
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
    fmt
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

{ lib, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, gobject-introspection
, glib
, gtk2
, gtk3
, gtk4
, fmt
, pcre
, libuuid
, libselinux
, libsepol
, libthai
, libdatrie
, libXdmcp
, libxkbcommon
, libepoxy
, dbus
, at-spi2-core
, libXtst
, withGTK2 ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-gtk";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-qckaD2VDlXyaXe52PTjYfKIJbsIBRgD5s3b9Oc6l/64=";
  };

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION_GIRDIR=share/gir-1.0"
    "-DGOBJECT_INTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ] ++ lib.optional (! withGTK2) "-DENABLE_GTK2_IM_MODULE=off";

  buildInputs = [
    glib
    gtk3
    gtk4
    fmt
    fcitx5
    pcre
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    libXdmcp
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libXtst
  ] ++ lib.optional withGTK2 gtk2;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gobject-introspection
  ];

  meta = with lib; {
    description = "Fcitx5 gtk im module and glib based dbus client library";
    homepage = "https://github.com/fcitx/fcitx5-gtk";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}

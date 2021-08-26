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
, epoxy
, dbus
, at-spi2-core
, libXtst
, withGTK2 ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-gtk";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "0vcikqrxv1xxcdaiz3axgm7rpab4w8aciw838sbpa9l20dp8cnyq";
  };

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION_GIRDIR=share/gir-1.0"
    "-DGOBJECT_INTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ] ++ lib.optional (! withGTK2) "-DENABLE_GTK2_IM_MODULE=off";

  buildInputs = [
    glib
    gtk3
    gtk4
    fmt
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

  NIX_CFLAGS_COMPILE = lib.concatMapStringsSep " " (s: "-isystem ${s}") [
    "${glib.dev}/include/gio-unix-2.0"
    "${glib.dev}/include/glib-2.0"
  ];

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

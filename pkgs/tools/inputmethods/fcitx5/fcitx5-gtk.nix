{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fcitx5,
  gobject-introspection,
  glib,
  gtk2,
  gtk3,
  gtk4,
  fmt,
  pcre,
  libuuid,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libXdmcp,
  libxkbcommon,
  libepoxy,
  dbus,
  at-spi2-core,
  libXtst,
  withGTK2 ? false,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-gtk";
<<<<<<< HEAD
  version = "5.1.5";
=======
  version = "5.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-eMo/ZsZdfAxR14aSnit3yHdw/yv8KdfKjK1Hu7Ce/3o=";
=======
    hash = "sha256-MlBLhgqpF+A9hotnhX83349wIpCQfzsqpyZb0xME2XQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION_GIRDIR=share/gir-1.0"
    "-DGOBJECT_INTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ]
  ++ lib.optional (!withGTK2) "-DENABLE_GTK2_IM_MODULE=off";

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
  ]
  ++ lib.optional withGTK2 gtk2;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gobject-introspection
  ];

<<<<<<< HEAD
  meta = {
    description = "Fcitx5 gtk im module and glib based dbus client library";
    homepage = "https://github.com/fcitx/fcitx5-gtk";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Fcitx5 gtk im module and glib based dbus client library";
    homepage = "https://github.com/fcitx/fcitx5-gtk";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

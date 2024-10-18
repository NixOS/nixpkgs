{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  cmake,
  dbus,
  glib,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "gdbuspp";
  version = "2";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "gdbuspp";
    rev = "v${version}";
    hash = "sha256-A0sl4zZa17zMec/jJASE8lDVNohzJzEGZbWjjsorB2Y=";
  };

  preConfigure = ''
    patchShebangs ./scripts/*
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    cmake
    ninja
  ];

  buildInputs = [
    dbus
    glib
  ];
}

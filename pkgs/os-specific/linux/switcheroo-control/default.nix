{ lib
, ninja
, meson
, fetchFromGitLab
, systemd
, libgudev
, pkg-config
, glib
, python3
, gobject-introspection
}:

python3.pkgs.buildPythonApplication rec {
  pname = "switcheroo-control";
  version = "2.6";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = pname;
    rev = version;
    hash = "sha256-F+5HhMxM8pcnAGmVBARKWNCL0rIEzHW/jsGHHqYZJug=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config

    # needed for glib-compile-resources
    glib
  ];

  buildInputs = [
    systemd
    libgudev
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dhwdbdir=${placeholder "out"}/etc/udev/hwdb.d"
  ];

  meta = with lib; {
    description = "D-Bus service to check the availability of dual-GPU";
    homepage = "https://gitlab.freedesktop.org/hadess/switcheroo-control/";
    changelog = "https://gitlab.freedesktop.org/hadess/switcheroo-control/-/blob/${version}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

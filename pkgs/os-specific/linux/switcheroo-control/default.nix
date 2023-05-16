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
<<<<<<< HEAD
  version = "2.6";
=======
  version = "2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-F+5HhMxM8pcnAGmVBARKWNCL0rIEzHW/jsGHHqYZJug=";
=======
    hash = "sha256-1Pze2TJ9mggfcpiLFwJ7/9WhsdJx4G3GoA7+Z47shuc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

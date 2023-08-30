{ lib
, stdenv
, fetchFromGitLab
, glib
, udev
, libgudev
, polkit
, ppp
, gettext
, pkg-config
, libxslt
, python3
, libmbim
, libqmi
, modemmanager
, systemd
, bash-completion
, meson
, ninja
, vala
, gobject-introspection
, dbus
}:

stdenv.mkDerivation rec {
  pname = "modemmanager";
  version = "1.20.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "ModemManager";
    rev = version;
    hash = "sha256-/A4WTsUQVeZDi5ei6qBvqoWYLKdRcZaYZU8/qWOPrvM=";
  };

  patches = [
    # Since /etc is the domain of NixOS, not Nix, we cannot install files there.
    # But these are just placeholders so we do not need to install them at all.
    ./no-dummy-dirs-in-sysconfdir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    gobject-introspection
    gettext
    pkg-config
    libxslt
  ];

  buildInputs = [
    glib
    udev
    libgudev
    polkit
    ppp
    libmbim
    libqmi
    systemd
    bash-completion
    dbus
  ];

  nativeInstallCheckInputs = [
    python3
    python3.pkgs.dbus-python
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    "-Ddbus_policy_dir=${placeholder "out"}/share/dbus-1/system.d"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dvapi=true"
  ];

  postPatch = ''
    patchShebangs \
      tools/test-modemmanager-service.py
  '';

  # In Nixpkgs g-ir-scanner is patched to produce absolute paths, and
  # that interferes with ModemManager's tests, causing them to try to
  # load libraries from the install path, which doesn't usually exist
  # when `make check' is run.  So to work around that, we run it as an
  # install check instead, when those paths will have been created.
  doInstallCheck = true;
  preInstallCheck = ''
    export G_TEST_DBUS_DAEMON="${dbus}/bin/dbus-daemon"
    patchShebangs tools/tests/test-wrapper.sh
  '';
  installCheckTarget = "check";

  passthru = {
    # provided FCC unlock scripts. Used by the NixOS module system to symlink
    # to them from /etc/ModemManager/fcc-unlock.d/….
    # Most of them actually symlink to a "common" unlock script
    fccUnlockScripts = {
      "03f0:4e1d" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/1199";
      "105b:e0ab" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/105b";
      "1199:9079" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/1199";
      "1eac:1001" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/1eac";
      "2c7c:030a" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/2c7c";
      "413c:81a3" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/1199";
      "413c:81a8" = "${modemmanager}/share/ModemManager/fcc-unlock.available.d/1199";
    };
  };

  meta = with lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = "https://www.freedesktop.org/wiki/Software/ModemManager/";
    license = licenses.gpl2Plus;
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
  };
}

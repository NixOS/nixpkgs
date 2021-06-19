{ lib, stdenv, fetchurl, fetchpatch
, glib, udev, libgudev, polkit, ppp, gettext, pkg-config, python3
, libmbim, libqmi, systemd, vala, gobject-introspection, dbus
}:

stdenv.mkDerivation rec {
  pname = "modem-manager";
  version = "1.16.6";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/ModemManager/ModemManager-${version}.tar.xz";
    sha256 = "05wn94x71qr36avxjzvyf56nj5illynnf9nn15b17lv61wkbd41a";
  };

  patches = [
    # Fix a broken test.
    # https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/556
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/commit/a324667386f35df0c3b3bbf615fa0560d215485d.patch";
      sha256 = "1xj9gfl6spbp4xdp6gn76k8zvzam5m6lgmbiwdn6ixffzhlfwi5l";
    })
  ];

  nativeBuildInputs = [ vala gobject-introspection gettext pkg-config ];

  buildInputs = [ glib udev libgudev polkit ppp libmbim libqmi systemd ];

  installCheckInputs = [
    python3 python3.pkgs.dbus-python python3.pkgs.pygobject3
  ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemd-suspend-resume"
    "--with-systemd-journal"
  ];

  postPatch = ''
    patchShebangs tools/test-modemmanager-service.py
  '';

  # In Nixpkgs g-ir-scanner is patched to produce absolute paths, and
  # that interferes with ModemManager's tests, causing them to try to
  # load libraries from the install path, which doesn't usually exist
  # when `make check' is run.  So to work around that, we run it as an
  # install check instead, when those paths will have been created.
  doInstallCheck = true;
  preInstallCheck = ''
    export G_TEST_DBUS_DAEMON="${dbus.daemon}/bin/dbus-daemon"
    patchShebangs tools/tests/test-wrapper.sh
  '';
  installCheckTarget = "check";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = "https://www.freedesktop.org/wiki/Software/ModemManager/";
    license = licenses.gpl2Plus;
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
  };
}

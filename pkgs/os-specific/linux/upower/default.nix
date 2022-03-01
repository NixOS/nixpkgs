{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, rsync
, libxslt
, meson
, ninja
, python3
, gtk-doc
, docbook_xsl
, udev
, libgudev
, libusb1
, glib
, gobject-introspection
, gettext
, systemd
, useIMobileDevice ? true
, libimobiledevice
}:

stdenv.mkDerivation rec {
  pname = "upower";
  version = "0.99.15";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "upower";
    rev = "v${version}";
    sha256 = "sha256-GlLy2MPip21KOabdW8Vw6NVe3xhzsd9htxQ2xO/hZ/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    gtk-doc
    docbook_xsl
    gettext
    gobject-introspection
    libxslt
    pkg-config
    rsync
  ];

  buildInputs = [
    libgudev
    libusb1
    udev
    systemd
  ] ++ lib.optionals useIMobileDevice [
    libimobiledevice
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Dos_backend=linux"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
  ];

  doCheck = false; # fails with "env: './linux/integration-test': No such file or directory"

  postPatch = ''
    patchShebangs src/linux/unittest_inspector.py
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    # We use rsync to merge the directories.
    for dir in etc var; do
        rsync --archive "${DESTDIR}/$dir" "$out"
        rm --recursive "${DESTDIR}/$dir"
    done
    for o in out dev; do
        rsync --archive "${DESTDIR}/''${!o}" "$(dirname "''${!o}")"
        rm --recursive "${DESTDIR}/''${!o}"
    done
    # Ensure the DESTDIR is removed.
    rmdir "${DESTDIR}/nix/store" "${DESTDIR}/nix" "${DESTDIR}"
  '';

  # HACK: We want to install configuration files to $out/etc
  # but upower should read them from /etc on a NixOS system.
  # With autotools, it was possible to override Make variables
  # at install time but Meson does not support this
  # so we need to convince it to install all files to a temporary
  # location using DESTDIR and then move it to proper one in postInstall.
  DESTDIR = "${placeholder "out"}/dest";

  meta = with lib; {
    homepage = "https://upower.freedesktop.org/";
    description = "A D-Bus service for power management";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}

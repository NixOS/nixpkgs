{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, pkg-config
, rsync
, libxslt
, meson
, ninja
, python3
, dbus
, umockdev
, libeatmydata
, gtk-doc
, docbook-xsl-nons
, udev
, libgudev
, libusb1
, glib
, gobject-introspection
, gettext
, systemd
, useIMobileDevice ? true
, libimobiledevice
, withDocs ? (stdenv.buildPlatform == stdenv.hostPlatform)
}:

stdenv.mkDerivation rec {
  pname = "upower";
  version = "0.99.19";

  outputs = [ "out" "dev" ]
    ++ lib.optionals withDocs [ "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "upower";
    rev = "v${version}";
    sha256 = "gpLsBh4jgiDO8bxic2BTFhjIwc2q/tuAIxykTHqK6UM=";
  };

  patches = [
    # Fix test
    # https://gitlab.freedesktop.org/upower/upower/-/merge_requests/150
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/upower/upower/-/commit/a78ee6039054770b466749f8ec4bfbe4c278d697.patch";
      sha256 = "aUPXnr/2PlOZNb7mQl43hmKe01DtuBUrGnqvwBFRf7Q=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
    gtk-doc
    docbook-xsl-nons
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

  checkInputs = [
    python3.pkgs.dbus-python
    python3.pkgs.python-dbusmock
    python3.pkgs.pygobject3
    dbus
    umockdev
    libeatmydata
    python3.pkgs.packaging
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
    "-Dudevhwdbdir=${placeholder "out"}/lib/udev/hwdb.d"
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "auto" else "disabled"}"
    "-Dgtk-doc=${lib.boolToString withDocs}"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs src/linux/integration-test.py
    patchShebangs src/linux/unittest_inspector.py
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overwitten during installation.
    mkdir -p "$out/lib"
    ln -s "$PWD/libupower-glib/libupower-glib.so" "$out/lib/libupower-glib.so.3"
  '';

  checkPhase = ''
    runHook preCheck

    # Slow fsync calls can make self-test fail:
    # https://gitlab.freedesktop.org/upower/upower/-/issues/195
    eatmydata meson test --print-errorlogs

    runHook postCheck
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
    changelog = "https://gitlab.freedesktop.org/upower/upower/-/blob/v${version}/NEWS";
    description = "A D-Bus service for power management";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}

{ lib
, stdenv
, fetchFromGitLab
<<<<<<< HEAD
, makeWrapper
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, gettext
, systemd
, nixosTests
, useIMobileDevice ? true
, libimobiledevice
, withDocs ? withIntrospection
, mesonEmulatorHook
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, buildPackages
, gobject-introspection
}:

assert withDocs -> withIntrospection;

stdenv.mkDerivation (finalAttrs: {
  pname = "upower";
  version = "1.90.2";

  outputs = [ "out" "dev" "installedTests" ]
=======
, gobject-introspection
, gettext
, systemd
, useIMobileDevice ? true
, libimobiledevice
, withDocs ? (stdenv.buildPlatform == stdenv.hostPlatform)
}:

stdenv.mkDerivation rec {
  pname = "upower";
  version = "1.90.0";

  outputs = [ "out" "dev" ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optionals withDocs [ "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "upower";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-7WzMAJuf1czU8ZalsEU/NwCXYqTGvcqEqxFt5ocgt48=";
  };

  patches = lib.optionals (stdenv.hostPlatform.system == "i686-linux") [
    # Remove when this is fixed upstream:
    # https://gitlab.freedesktop.org/upower/upower/-/issues/214
    ./i686-test-remove-battery-check.patch
  ] ++ [
    ./installed-tests-path.patch
  ];
=======
    rev = "v${version}";
    hash = "sha256-+C/4dDg6WTLpBgkpNyxjthSdqYdaTLC8vG6jG1LNJ7w=";
  };

  # Remove when this is fixed upstream:
  # https://gitlab.freedesktop.org/upower/upower/-/issues/214
  patches = lib.optional (stdenv.hostPlatform.system == "i686-linux")
    ./i686-test-remove-battery-check.patch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
<<<<<<< HEAD
    docbook-xsl-nons
    gettext
    libxslt
    makeWrapper
    pkg-config
    rsync
    glib
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals withDocs [
    gtk-doc
  ] ++ lib.optionals (withDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
=======
    gtk-doc
    docbook-xsl-nons
    gettext
    gobject-introspection
    libxslt
    pkg-config
    rsync
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    libgudev
    libusb1
    udev
    systemd
    # Duplicate from nativeCheckInputs until https://github.com/NixOS/nixpkgs/issues/161570 is solved
    umockdev
<<<<<<< HEAD

    # For installed tests.
    (python3.withPackages (pp: [
      pp.dbus-python
      pp.python-dbusmock
      pp.pygobject3
      pp.packaging
    ]))
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals useIMobileDevice [
    libimobiledevice
  ];

  nativeCheckInputs = [
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
<<<<<<< HEAD
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonBool "gtk-doc" withDocs)
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
=======
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "auto" else "disabled"}"
    "-Dgtk-doc=${lib.boolToString withDocs}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs src/linux/integration-test.py
    patchShebangs src/linux/unittest_inspector.py
<<<<<<< HEAD

    substituteInPlace src/linux/integration-test.py \
      --replace "/usr/share/dbus-1" "$out/share/dbus-1"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postCheck = ''
    # Undo patchShebangs from postPatch so that it can be replaced with runtime shebang
    # unittest_inspector.py intentionally not reverted because it would trigger
    # meson rebuild during install and it is not used at runtime anyway.
    sed -Ei 's~#!.+/bin/python3~#!/usr/bin/python3~' \
      ../src/linux/integration-test.py
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    # We use rsync to merge the directories.
    for dir in etc var; do
<<<<<<< HEAD
        rsync --archive "$DESTDIR/$dir" "$out"
        rm --recursive "$DESTDIR/$dir"
    done
    for o in out dev installedTests; do
        rsync --archive "$DESTDIR/''${!o}" "$(dirname "''${!o}")"
        rm --recursive "$DESTDIR/''${!o}"
    done
    # Ensure the DESTDIR is removed.
    rmdir "$DESTDIR/nix/store" "$DESTDIR/nix" "$DESTDIR"
  '';

  postFixup = ''
    wrapProgram "$installedTests/libexec/upower/integration-test.py" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [
        "$out"
        umockdev.out
      ]}" \
      --prefix PATH : "${lib.makeBinPath [
        umockdev
      ]}"
  '';

  env = {
    # HACK: We want to install configuration files to $out/etc
    # but upower should read them from /etc on a NixOS system.
    # With autotools, it was possible to override Make variables
    # at install time but Meson does not support this
    # so we need to convince it to install all files to a temporary
    # location using DESTDIR and then move it to proper one in postInstall.
    DESTDIR = "${placeholder "out"}/dest";
  };

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.upower;
    };
  };

  meta = with lib; {
    homepage = "https://upower.freedesktop.org/";
    changelog = "https://gitlab.freedesktop.org/upower/upower/-/blob/v${finalAttrs.version}/NEWS";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A D-Bus service for power management";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

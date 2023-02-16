{ lib, stdenv
, substituteAll
, fetchFromGitHub
, autoreconfHook
, gettext
, makeWrapper
, pkg-config
, vala
, wrapGAppsHook
, dbus
, systemd
, dconf ? null
, glib
, gdk-pixbuf
, gobject-introspection
, gtk2
, gtk3
, gtk4
, gtk-doc
, runCommand
, isocodes
, cldr-annotations
, unicode-character-database
, unicode-emoji
, python3
, json-glib
, libnotify ? null
, enableUI ? true
, withWayland ? false
, libxkbcommon
, wayland
, buildPackages
, runtimeShell
, nixosTests
}:

let
  python3Runtime = python3.withPackages (ps: with ps; [ pygobject3 ]);
  python3BuildEnv = python3.buildEnv.override {
    # ImportError: No module named site
    postBuild = ''
      makeWrapper ${glib.dev}/bin/gdbus-codegen $out/bin/gdbus-codegen --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-genmarshal $out/bin/glib-genmarshal --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-mkenums $out/bin/glib-mkenums --unset PYTHONPATH
    '';
  };
  # make-dconf-override-db.sh needs to execute dbus-launch in the sandbox,
  # it will fail to read /etc/dbus-1/session.conf unless we add this flag
  dbus-launch = runCommand "sandbox-dbus-launch" {
    nativeBuildInputs = [ makeWrapper ];
  } ''
      makeWrapper ${dbus}/bin/dbus-launch $out/bin/dbus-launch \
        --add-flags --config-file=${dbus}/share/dbus-1/session.conf
  '';
in

stdenv.mkDerivation rec {
  pname = "ibus";
  version = "1.5.27";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    rev = version;
    sha256 = "sha256-DwX7SYRb18C0Lz2ySPS3yV99Q1xQezs0Ls2P7Rbtk5Q=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      pythonInterpreter = python3Runtime.interpreter;
      pythonSitePackages = python3.sitePackages;
    })
  ];

  outputs = [ "out" "dev" "installedTests" ];

  postPatch = ''
    patchShebangs --build data/dconf/make-dconf-override-db.sh
    cp ${buildPackages.gtk-doc}/share/gtk-doc/data/gtk-doc.make .
    substituteInPlace bus/services/org.freedesktop.IBus.session.GNOME.service.in --replace "ExecStart=sh" "ExecStart=${runtimeShell}"
    substituteInPlace bus/services/org.freedesktop.IBus.session.generic.service.in --replace "ExecStart=sh" "ExecStart=${runtimeShell}"
  '';

  preAutoreconf = "touch ChangeLog";

  configureFlags = [
    "--disable-memconf"
    (lib.enableFeature (dconf != null) "dconf")
    (lib.enableFeature (libnotify != null) "libnotify")
    (lib.enableFeature withWayland "wayland")
    (lib.enableFeature enableUI "ui")
    "--enable-gtk4"
    "--enable-install-tests"
    "--with-unicode-emoji-dir=${unicode-emoji}/share/unicode/emoji"
    "--with-emoji-annotation-dir=${cldr-annotations}/share/unicode/cldr/common/annotations"
    "--with-ucd-dir=${unicode-character-database}/share/unicode"
  ];

  makeFlags = [
    "test_execsdir=${placeholder "installedTests"}/libexec/installed-tests/ibus"
    "test_sourcesdir=${placeholder "installedTests"}/share/installed-tests/ibus"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    gettext
    makeWrapper
    pkg-config
    python3BuildEnv
    vala
    wrapGAppsHook
    dbus-launch
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    dbus
    systemd
    dconf
    gdk-pixbuf
    gobject-introspection
    python3.pkgs.pygobject3 # for pygobject overrides
    gtk2
    gtk3
    gtk4
    isocodes
    json-glib
    libnotify
  ] ++ lib.optionals withWayland [
    libxkbcommon
    wayland
  ];

  enableParallelBuilding = true;

  doCheck = false; # requires X11 daemon
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ibus version
  '';

  postInstall = ''
    # It has some hardcoded FHS paths and also we do not use it
    # since we set up the environment in NixOS tests anyway.
    moveToOutput "bin/ibus-desktop-testing-runner" "$installedTests"
  '';

  postFixup = ''
    # set necessary environment also for tests
    for f in $installedTests/libexec/installed-tests/ibus/*; do
        wrapGApp $f
    done
  '';

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.ibus;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/ibus/ibus";
    description = "Intelligent Input Bus, input method framework";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel yana ];
  };
}

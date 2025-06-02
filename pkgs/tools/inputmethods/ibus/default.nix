{
  lib,
  stdenv,
  replaceVars,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  makeWrapper,
  pkg-config,
  vala,
  wrapGAppsHook3,
  dbus,
  systemd,
  dconf ? null,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  gtk4,
  gtk-doc,
  libdbusmenu-gtk3,
  runCommand,
  isocodes,
  cldr-annotations,
  unicode-character-database,
  unicode-emoji,
  python3,
  json-glib,
  libnotify ? null,
  enableUI ? !libOnly,
  withWayland ? !libOnly,
  libxkbcommon,
  wayland,
  buildPackages,
  runtimeShell,
  nixosTests,
  versionCheckHook,
  nix-update-script,
  libX11,
  libOnly ? false,
}:

let
  python3Runtime = python3.withPackages (ps: with ps; [ pygobject3 ]);
  python3BuildEnv = python3.pythonOnBuildForHost.buildEnv.override {
    # ImportError: No module named site
    postBuild = ''
      makeWrapper ${glib.dev}/bin/gdbus-codegen $out/bin/gdbus-codegen --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-genmarshal $out/bin/glib-genmarshal --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-mkenums $out/bin/glib-mkenums --unset PYTHONPATH
    '';
  };
  # make-dconf-override-db.sh needs to execute dbus-launch in the sandbox,
  # it will fail to read /etc/dbus-1/session.conf unless we add this flag
  dbus-launch =
    runCommand "sandbox-dbus-launch"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        makeWrapper ${dbus}/bin/dbus-launch $out/bin/dbus-launch \
          --add-flags --config-file=${dbus}/share/dbus-1/session.conf
      '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus";
  version = "1.5.31";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    tag = finalAttrs.version;
    hash = "sha256-YMCtLIK/9iUdS37Oiow7WMhFFPKhomNXvzWbLzlUkdQ=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      pythonInterpreter = python3Runtime.interpreter;
      pythonSitePackages = python3.sitePackages;
      # patch context
      prefix = null;
      datarootdir = null;
      localedir = null;
      # removed line only
      PYTHON = null;
    })
    ./build-without-dbus-launch.patch
  ];

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals (!libOnly) [
    "installedTests"
  ];

  postPatch = ''
    # Maintainer does not want to create separate tarballs for final release candidate and release versions,
    # so we need to set `ibus_released` to `1` in `configure.ac`. Otherwise, anyone running `ibus version` gets
    # a version with an inaccurate `-rcX` suffix.
    # https://github.com/ibus/ibus/issues/2584
    substituteInPlace configure.ac --replace "m4_define([ibus_released], [0])" "m4_define([ibus_released], [1])"

    patchShebangs --build data/dconf/make-dconf-override-db.sh
    cp ${buildPackages.gtk-doc}/share/gtk-doc/data/gtk-doc.make .
    substituteInPlace bus/services/org.freedesktop.IBus.session.GNOME.service.in --replace "ExecStart=sh" "ExecStart=${runtimeShell}"
    substituteInPlace bus/services/org.freedesktop.IBus.session.generic.service.in --replace "ExecStart=sh" "ExecStart=${runtimeShell}"
  '';

  preAutoreconf = "touch ChangeLog";

  configureFlags = [
    # The `AX_PROG_{CC,CXX}_FOR_BUILD` autoconf macros can pick up unwrapped GCC binaries,
    # so we set `{CC,CXX}_FOR_BUILD` to override that behavior.
    # https://github.com/NixOS/nixpkgs/issues/21751
    "CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "CXX_FOR_BUILD=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++"
    "GLIB_COMPILE_RESOURCES=${lib.getDev buildPackages.glib}/bin/glib-compile-resources"
    "PKG_CONFIG_VAPIGEN_VAPIGEN=${lib.getBin buildPackages.vala}/bin/vapigen"
    "--disable-memconf"
    "--disable-gtk2"
    "--with-python=${python3BuildEnv.interpreter}"
    (lib.enableFeature (!libOnly && dconf != null) "dconf")
    (lib.enableFeature (!libOnly && libnotify != null) "libnotify")
    (lib.enableFeature withWayland "wayland")
    (lib.enableFeature enableUI "ui")
    (lib.enableFeature (!libOnly) "gtk3")
    (lib.enableFeature (!libOnly) "gtk4")
    (lib.enableFeature (!libOnly) "xim")
    (lib.enableFeature (!libOnly) "appindicator")
    (lib.enableFeature (!libOnly) "tests")
    (lib.enableFeature (!libOnly) "install-tests")
    (lib.enableFeature (!libOnly) "emoji-dict")
    (lib.enableFeature (!libOnly) "unicode-dict")
  ]
  ++ lib.optionals (!libOnly) [
    "--with-unicode-emoji-dir=${unicode-emoji}/share/unicode/emoji"
    "--with-emoji-annotation-dir=${cldr-annotations}/share/unicode/cldr/common/annotations"
    "--with-ucd-dir=${unicode-character-database}/share/unicode"
  ];

  makeFlags = lib.optionals (!libOnly) [
    "test_execsdir=${placeholder "installedTests"}/libexec/installed-tests/ibus"
    "test_sourcesdir=${placeholder "installedTests"}/share/installed-tests/ibus"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    gettext
    makeWrapper
    pkg-config
    python3BuildEnv
    glib # required to satisfy AM_PATH_GLIB_2_0
    vala
    dbus-launch
    gobject-introspection
  ]
  ++ lib.optionals (!libOnly) [
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    dbus
    systemd
    dconf
    python3.pkgs.pygobject3 # for pygobject overrides
    isocodes
    json-glib
    libX11
  ]
  ++ lib.optionals (!libOnly) [
    gtk3
    gtk4
    gdk-pixbuf
    libdbusmenu-gtk3
    libnotify
    vala # for share/vala/Makefile.vapigen (PKG_CONFIG_VAPIGEN_VAPIGEN)
  ]
  ++ lib.optionals withWayland [
    libxkbcommon
    wayland
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  doCheck = false; # requires X11 daemon

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  versionCheckProgram = "${placeholder "out"}/bin/ibus";

  postInstall = lib.optionalString (!libOnly) ''
    # It has some hardcoded FHS paths and also we do not use it
    # since we set up the environment in NixOS tests anyway.
    moveToOutput "bin/ibus-desktop-testing-runner" "$installedTests"
  '';

  postFixup = lib.optionalString (!libOnly) ''
    # set necessary environment also for tests
    for f in $installedTests/libexec/installed-tests/ibus/*; do
        wrapGApp $f
    done
  '';

  passthru = {
    tests = lib.optionalAttrs (!libOnly) {
      installed-tests = nixosTests.installed-tests.ibus;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/ibus/ibus/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/ibus/ibus";
    description = "Intelligent Input Bus, input method framework";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ttuegel ];
  };
})

{ stdenv
, substituteAll
, fetchurl
, fetchFromGitHub
, autoreconfHook
, gettext
, makeWrapper
, pkgconfig
, vala
, wrapGAppsHook
, dbus
, dconf ? null
, glib
, gdk-pixbuf
, gobject-introspection
, gtk2
, gtk3
, gtk-doc
, isocodes
, cldr-emoji-annotation
, unicode-character-database
, unicode-emoji
, python3
, json-glib
, libnotify ? null
, enablePython2Library ? false
, enableUI ? true
, withWayland ? false
, libxkbcommon ? null
, wayland ? null
, buildPackages
, runtimeShell
, nixosTests
}:

assert withWayland -> wayland != null && libxkbcommon != null;

with stdenv.lib;

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
in

stdenv.mkDerivation rec {
  pname = "ibus";
  version = "1.5.22";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    rev = version;
    sha256 = "09ynn7gq84q18hhbg6wq2yrliwil42qbzxbwbpggry1s955jg5xb";
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
    echo \#!${runtimeShell} > data/dconf/make-dconf-override-db.sh
    cp ${buildPackages.gtk-doc}/share/gtk-doc/data/gtk-doc.make .
  '';

  preAutoreconf = "touch ChangeLog";

  configureFlags = [
    "--disable-memconf"
    (enableFeature (dconf != null) "dconf")
    (enableFeature (libnotify != null) "libnotify")
    (enableFeature withWayland "wayland")
    (enableFeature enablePython2Library "python-library")
    (enableFeature enablePython2Library "python2") # XXX: python2 library does not work anyway
    (enableFeature enableUI "ui")
    "--enable-install-tests"
    "--with-unicode-emoji-dir=${unicode-emoji}/share/unicode/emoji"
    "--with-emoji-annotation-dir=${cldr-emoji-annotation}/share/unicode/cldr/common/annotations"
    "--with-ucd-dir=${unicode-character-database}/share/unicode"
  ];

  makeFlags = [
    "test_execsdir=${placeholder ''installedTests''}/libexec/installed-tests/ibus"
    "test_sourcesdir=${placeholder ''installedTests''}/share/installed-tests/ibus"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    gettext
    makeWrapper
    pkgconfig
    python3BuildEnv
    vala
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    dbus
    dconf
    gdk-pixbuf
    gobject-introspection
    python3.pkgs.pygobject3 # for pygobject overrides
    gtk2
    gtk3
    isocodes
    json-glib
    libnotify
  ] ++ optionals withWayland [
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

  meta = {
    homepage = "https://github.com/ibus/ibus";
    description = "Intelligent Input Bus, input method framework";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel yegortimoshenko ];
  };
}

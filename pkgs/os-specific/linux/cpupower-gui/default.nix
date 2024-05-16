{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, buildPythonApplication
, appstream-glib
, dbus-python
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk3
, hicolor-icon-theme
, libappindicator
, libhandy
, meson
, ninja
, pkg-config
, pygobject3
, pyxdg
, systemd
, wrapGAppsHook3
}:

buildPythonApplication rec {
  pname = "cpupower-gui";
  version = "1.0.0";

  # This packages doesn't have a setup.py
  format = "other";

  src = fetchFromGitHub {
    owner = "vagnum08";
    repo = pname;
    rev = "v${version}";
    sha256 = "05lvpi3wgyi741sd8lgcslj8i7yi3wz7jwl7ca3y539y50hwrdas";
  };

  patches = [
    # Fix build with 0.61, can be removed on next update
    # https://hydra.nixos.org/build/171052557/nixlog/1
    (fetchpatch {
      url = "https://github.com/vagnum08/cpupower-gui/commit/97f8ac02fe33e412b59d3f3968c16a217753e74b.patch";
      sha256 = "XYnpm03kq8JLMjAT73BMCJWlzz40IAuHESm715VV6G0=";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils # needed for update-desktop-database
    gettext
    glib # needed for glib-compile-schemas
    gobject-introspection # need for gtk namespace to be available
    hicolor-icon-theme # needed for postinstall script
    meson
    ninja
    pkg-config
    wrapGAppsHook3

    # Python packages
    dbus-python
    libappindicator
    pygobject3
    pyxdg
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
  ];

  propagatedBuildInputs = [
    dbus-python
    libappindicator
    pygobject3
    pyxdg
  ];

  mesonFlags = [
    "-Dsystemddir=${placeholder "out"}/lib/systemd"
  ];

  preConfigure = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  strictDeps = false;
  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postFixup = ''
    wrapPythonProgramsIn $out/lib "$out $propagatedBuildInputs"
  '';

  meta = with lib; {
    description = "Change the frequency limits of your cpu and its governor";
    mainProgram = "cpupower-gui";
    homepage = "https://github.com/vagnum08/cpupower-gui/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ unode ];
  };
}

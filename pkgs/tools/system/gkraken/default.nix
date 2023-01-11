{ python3Packages
, lib
, fetchFromGitLab
, meson
, pkg-config
, glib
, ninja
, desktop-file-utils
, gobject-introspection
, gtk3
, libnotify
, dbus
, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "gkraken";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "leinardi";
    repo = "gkraken";
    rev = version;
    sha256 = "0hxlh0319rl28iba02917z3n6d5cq2qcgpj2ng31bkjjhlvvfm2g";
  };

  format = "other";

  postPatch = ''
    patchShebangs scripts/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    gobject-introspection
    glib
    ninja
    gtk3
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    glib
    gtk3
    libnotify
    dbus
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    peewee
    rx
    injector
    liquidctl
    pyxdg
    requests
    matplotlib
    dbus-python
  ];

  dontWrapGApps = true;

  # Extract udev rules from python code
  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed -e '/\s*\(from\|@singleton\|@inject\)/d' $src/gkraken/interactor/udev_interactor.py > udev_interactor.py
    python -c 'from udev_interactor import _UDEV_RULE; print(_UDEV_RULE)' > $out/lib/udev/rules.d/60-gkraken.rules
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    description = "GUI that allows to control the cooling (fan and/or pump profiles) of NZXT Kraken AIO liquid coolers from Linux";
    homepage = "https://gitlab.com/leinardi/gkraken";
    changelog = "https://gitlab.com/leinardi/gkraken/-/tags/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}

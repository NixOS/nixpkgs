{ lib
, fetchFromGitLab
, gobject-introspection
, pciutils
, python3Packages
, gtk3
, wrapGAppsHook
, glib
, cairo
, desktop-file-utils
, xdg-utils
, xdg-user-dirs
, gettext
, winetricks
, wine
, glxinfo
}:

python3Packages.buildPythonApplication rec  {
  pname = "grapejuice";
  version = "5.5.4";

  src = fetchFromGitLab {
    owner = "BrinkerVII";
    repo = "grapejuice";
    rev = "v${version}";
    sha256 = "sha256-y4J0589FgNahRmoPkVtHYtc6/OIfUi9bhz6BZrSeWVI=";
  };

  nativeBuildInputs = [
    gobject-introspection
    desktop-file-utils
    glib
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    gettext
    gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    psutil
    dbus-python
    pygobject3
    packaging
    wheel
    setuptools
    requests
    unidecode
    click
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ xdg-user-dirs wine winetricks pciutils glxinfo ]}"
    # make xdg-open overrideable at runtime
    "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  postPatch = ''
    substituteInPlace src/grapejuice_common/assets/desktop/grapejuice.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$GRAPEJUICE_GUI_EXECUTABLE "$out/bin/grapejuice-gui" \
      --replace \$GRAPEJUICE_ICON grapejuice

    substituteInPlace src/grapejuice_common/assets/desktop/roblox-player.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$PLAYER_ICON "grapejuice-roblox-player"

    substituteInPlace src/grapejuice_common/assets/desktop/roblox-app.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$PLAYER_ICON "grapejuice-roblox-player"

    substituteInPlace src/grapejuice_common/assets/desktop/roblox-studio.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$STUDIO_ICON "grapejuice-roblox-studio"

    substituteInPlace src/grapejuice_common/paths.py \
      --replace 'return local_share() / "locale"' 'return Path("${placeholder "out"}/share/locale")'

    substituteInPlace src/grapejuice_common/features/settings.py \
      --replace 'k_default_wine_home: "",' 'k_default_wine_home: "${wine}",'
  '';

  postInstall = ''
    mkdir -p "$out/share/icons" "$out/share/applications" "$out/share/mime/packages"
    cp -r src/grapejuice_common/assets/desktop/* $out/share/applications/
    cp -r src/grapejuice_common/assets/icons $out/share/
    cp src/grapejuice_common/assets/mime_xml/*.xml $out/share/mime/packages/

    # compile locales (*.po -> *.mo)
    # from https://gitlab.com/brinkervii/grapejuice/-/blob/master/src/grapejuice_common/util/mo_util.py
    LOCALE_DIR="$out/share/locale"
    PO_DIR="src/grapejuice_common/assets/po"
    LINGUAS_FILE="src/grapejuice_common/assets/po/LINGUAS"

    for lang in $(<"$LINGUAS_FILE") # extract langs from LINGUAS_FILE
    do
      po_file="$PO_DIR/$lang.po"
      mo_file_dir="$LOCALE_DIR/$lang/LC_MESSAGES"

      mkdir -p $mo_file_dir

      mo_file="$mo_file_dir/grapejuice.mo"
      msgfmt $po_file -o $mo_file # msgfmt from gettext
    done
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "grapejuice" ];

  meta = with lib; {
    homepage = "https://gitlab.com/brinkervii/grapejuice";
    description = "Simple Wine+Roblox management tool";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin helium ];
  };
}

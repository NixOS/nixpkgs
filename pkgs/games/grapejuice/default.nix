{ lib
, fetchFromGitLab
, gobject-introspection
, python3Packages
, gtk3
, wrapGAppsHook
, glib
, cairo
, desktop-file-utils
, xdg-utils
, xdg-user-dirs
, wine
, winetricks
, pciutils
, glxinfo
}:

python3Packages.buildPythonApplication rec  {
  pname = "grapejuice";
  version = "4.10.2";

  src = fetchFromGitLab {
    owner = "BrinkerVII";
    repo = "grapejuice";
    rev = "9a7cf806d35b4d53b3d3762339eba7d861b5043d";
    sha256 = "sha256-cKZv9qPCnl7i4kb6PG8RYx3HNLcwgI4d2zkw899MA6E=";
  };

  nativeBuildInputs = [
    gobject-introspection
    desktop-file-utils
    glib
    gtk3
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    pygobject3
    dbus-python
    packaging
    psutil
    setuptools
    unidecode
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ xdg-user-dirs xdg-utils wine winetricks pciutils glxinfo ]}"
  ];

  postPatch = ''
    substituteInPlace src/grapejuice_common/assets/desktop/grapejuice.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
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
  '';

  postInstall = ''
    mkdir -p "$out/share/icons" "$out/share/applications" "$out/share/mime/packages"
    cp -r src/grapejuice_common/assets/desktop/* $out/share/applications/
    cp -r src/grapejuice_common/assets/icons $out/share/
    cp src/grapejuice_common/assets/mime_xml/*.xml $out/share/mime/packages/
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "grapejuice" ];

  meta = with lib; {
    homepage = "https://gitlab.com/brinkervii/grapejuice";
    description = "A wine+Roblox management application";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}

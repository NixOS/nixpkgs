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
}:

python3Packages.buildPythonApplication rec  {
  pname = "grapejuice";
  version = "3.64.16";

  src = fetchFromGitLab {
    owner = "BrinkerVII";
    repo = "grapejuice";
    rev = "a5bc65e094bbfb86e6142ac1da59017ddccff69e";
    sha256 = "sha256-3+5LWn+UBgLAX683MPHRHQMpW+gC5hGIwTtRVJHRWeE=";
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
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ xdg-user-dirs xdg-utils wine winetricks ]}"
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
    description = "Simple Wine+Roblox management tool";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}

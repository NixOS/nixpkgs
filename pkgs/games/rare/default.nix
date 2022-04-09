{ lib, fetchPypi, buildPythonApplication, makeDesktopItem, copyDesktopItems, qt5
, pillow, psutil, pypresence, pyqt5, python, qtawesome, requests }:

buildPythonApplication rec {
  pname = "rare";
  version = "1.8.8";

  src = fetchPypi {
    inherit version;
    pname = "Rare";
    sha256 = "sha256-00CtvBqSrT9yJUHZ5529VrIQtCOYkHRc8+rJHmrTSpg=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    pillow
    psutil
    pypresence
    pyqt5
    qtawesome
    requests
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "rare";
      icon = "Rare";
      comment = meta.description;
      desktopName = "Rare";
      genericName = "Rare (Epic Games Launcher Open Source Alternative)";
    })
  ];

  dontWrapQtApps = true;

  preBuild = ''
    # Solves "PermissionError: [Errno 13] Permission denied: '/homeless-shelter'"
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    install -Dm644 $out/${python.sitePackages}/rare/resources/images/Rare.png -t $out/share/pixmaps/
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "GUI for Legendary, an Epic Games Launcher open source alternative";
    homepage = "https://github.com/Dummerle/Rare";
    maintainers = with maintainers; [ wolfangaukang ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}

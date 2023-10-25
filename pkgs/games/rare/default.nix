{ lib
, fetchFromGitHub
, buildPythonApplication
, qt5
, legendary-gl
, pypresence
, pyqt5
, python
, qtawesome
, requests
, typing-extensions
}:

buildPythonApplication rec {
  pname = "rare";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "Dummerle";
    repo = "Rare";
    rev = "refs/tags/${version}";
    hash = "sha256-7KER9gCpqjEKikQTVHsvwX6efCb9L0ut6OBjjLBW2tI=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    legendary-gl
    pypresence
    pyqt5
    qtawesome
    requests
    typing-extensions
  ];

  patches = [
    # Not able to run pythonRelaxDepsHook because of https://github.com/NixOS/nixpkgs/issues/198342
    ./legendary-gl-version.patch
  ];

  dontWrapQtApps = true;

  postInstall = ''
    install -Dm644 misc/rare.desktop -t $out/share/applications/
    install -Dm644 $out/${python.sitePackages}/rare/resources/images/Rare.png $out/share/pixmaps/rare.png
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

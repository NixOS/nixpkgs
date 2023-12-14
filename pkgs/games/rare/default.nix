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
, setuptools
, typing-extensions
}:

buildPythonApplication rec {
  pname = "rare";
  version = "1.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RareDevs";
    repo = "Rare";
    rev = "refs/tags/${version}";
    hash = "sha256-rV6B9tCdwWK9yvEtVyLnv4Lo1WP5xW0f4JcsNZ7iBGI=";
  };

  nativeBuildInputs = [
    setuptools
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
    homepage = "https://github.com/RareDevs/Rare";
    maintainers = with maintainers; [ wolfangaukang ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "rare";
  };
}

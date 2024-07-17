{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  qt5,
  legendary-gl,
  orjson,
  pypresence,
  pyqt5,
  python,
  qtawesome,
  requests,
  setuptools,
  typing-extensions,
}:

buildPythonApplication rec {
  pname = "rare";
  version = "1.10.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RareDevs";
    repo = "Rare";
    rev = "refs/tags/${version}";
    hash = "sha256-2DtI5iaK4bYdGfIEhPy52WaEqh+IJMZ6qo/348lMnLY=";
  };

  nativeBuildInputs = [
    setuptools
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    legendary-gl
    orjson
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
    maintainers = [ ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "rare";
  };
}

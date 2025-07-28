{
  lib,
  fetchFromGitHub,
  qt5,
  python3,
  legendary-gl,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rare";
  version = "1.10.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RareDevs";
    repo = "Rare";
    tag = version;
    hash = "sha256-2DtI5iaK4bYdGfIEhPy52WaEqh+IJMZ6qo/348lMnLY=";
  };

  build-system = builtins.attrValues {
    inherit (python3.pkgs)
      poetry-core
      setuptools-scm
      wheel
      ;
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dependencies = builtins.attrValues {
    inherit (python3.pkgs)
      orjson
      pypresence
      pyqt5
      qtawesome
      requests
      typing-extensions
      ;
    inherit legendary-gl;
  };

  dontWrapQtApps = true;

  postInstall = ''
    install -Dm644 misc/rare.desktop -t $out/share/applications/
    install -Dm644 $out/${python3.sitePackages}/rare/resources/images/Rare.png $out/share/pixmaps/rare.png
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

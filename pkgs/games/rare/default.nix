{
  lib,
  fetchFromGitHub,
  libsForQt5,
  python3,
  legendary-gl,
}:

let
  version = "1.10.11";
in
python3.pkgs.buildPythonApplication {
  pname = "rare";
  inherit version;
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

  nativeBuildInputs = [ libsForQt5.qt5.wrapQtAppsHook ];

  dependencies = builtins.attrValues {
    inherit (python3.pkgs)
      orjson
      pypresence
      pyqt5
      qtawesome
      requests
      typing-extensions
      ;
  };

  propagatedBuildInputs = [ legendary-gl ];

  postInstall = ''
    install -Dm 0644 misc/rare.desktop -t $out/share/applications/
    install -Dm 0644 rare/resources/images/Rare.png $out/share/icons/hicolor/512x512/apps/rare.png
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Alternative for Epic Games Launcher, using Legendary";
    homepage = "https://github.com/RareDevs/Rare";
    maintainers = [ ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "rare";
  };
}

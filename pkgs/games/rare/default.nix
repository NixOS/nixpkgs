{ lib, fetchFromGitHub, buildPythonApplication, qt5
, psutil, pypresence, pyqt5, python, qtawesome, requests }:

buildPythonApplication rec {
  pname = "rare";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "Dummerle";
    repo = "Rare";
    rev = version;
    sha256 = "sha256-2l8Id+bA5Ugb8+3ioiZ78dUtDusU8cvZEAMhmYBcJFc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    psutil
    pypresence
    pyqt5
    qtawesome
    requests
  ];

  dontWrapQtApps = true;

  preBuild = ''
    # Solves "PermissionError: [Errno 13] Permission denied: '/homeless-shelter'"
    export HOME=$(mktemp -d)
  '';

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

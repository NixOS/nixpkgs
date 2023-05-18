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
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "Dummerle";
    repo = "Rare";
    rev = "refs/tags/${version}";
    sha256 = "sha256-+STwVsDdvjP7HaqmaQVug+6h0n0rw/j4LGQQSNdLVQQ=";
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
    ./fix-instance.patch
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

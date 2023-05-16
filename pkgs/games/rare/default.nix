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
<<<<<<< HEAD
  version = "1.10.3";
=======
  version = "1.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Dummerle";
    repo = "Rare";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-7KER9gCpqjEKikQTVHsvwX6efCb9L0ut6OBjjLBW2tI=";
=======
    sha256 = "sha256-+STwVsDdvjP7HaqmaQVug+6h0n0rw/j4LGQQSNdLVQQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    ./fix-instance.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

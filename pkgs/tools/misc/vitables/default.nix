{ lib, pkgs, fetchFromGitHub, buildPythonPackage, python3Packages, hatchling, qt6, ... }:

buildPythonPackage rec {
  pname = "vitables";
  version = "3.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    inherit version;
    owner = "uvemas";
    repo = "ViTables";
    rev = "8ab92d1142579ea8df72737beb6696733cf8b510";
    sha256 = "sha256-tnf0qjjxyyVywPs6XicIS2VneYRiZ4f5WK0fUz42zAQ=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    hatchling
  ];

  propagatedBuildInputs = [
    qt6.qtbase
  ] ++ (with python3Packages; [
    numexpr
    numpy
    pyqt6
    qtpy
    tables
  ]);

  # Tests segfault and largely depend on GUIs
  doCheck = false;

  preFixup = ''
    wrapQtApp "$out/bin/vitables"
  '';

  meta = {
    description = ''
      A graphical tool for browsing and editing files in both PyTables and HDF5
      format
    '';
    homepage = "https://vitables.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ williamvds ];
  };
}

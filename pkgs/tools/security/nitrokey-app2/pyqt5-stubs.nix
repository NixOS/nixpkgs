{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyqt5
, pyqtwebengine
, pyqtchart
, pyqt3d
, pyqtdatavisualization
, pytestCheckHook
, pytest-xvfb
}:

buildPythonPackage rec {
  pname = "pyqt5-stubs";
  version = "5.15.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-qt-tools";
    repo = "PyQt5-stubs";
    rev = version;
    hash = "sha256-qWnvlHnFRy8wbZJ28C0pYqAxod623Epe5z5FZufheDc=";
  };

  postPatch = ''
    # pulls in a dependency to mypy, but we don't want to run linters
    rm tests/test_stubs.py
    '';

  propagatedBuildInputs = [
    pyqt5
    pyqtwebengine
    pyqtchart
    pyqt3d
    pyqtdatavisualization
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xvfb
  ];

  disabledTests = [
    "test_files"
  ];

  pythonImportsCheck = [
    "PyQt5-stubs"
  ];

  meta = with lib; {
    description = "PEP561 stub files for the PyQt5 framework";
    homepage = "https://github.com/python-qt-tools/PyQt5-stubs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ panicgh ];
  };
}

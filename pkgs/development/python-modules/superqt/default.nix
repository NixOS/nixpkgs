{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pyqt5
, qtpy
, typing-extensions
, pytestCheckHook
, pygments
}:

buildPythonPackage rec {
  pname = "superqt";
  version = "0.3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zEMG2zscGDlRxtLn/lUTEjZBPabcwzMcj/kMcy3yOs8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pyqt5
    qtpy
    typing-extensions
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # Segfaults...

  pythonImportsCheck = [ "superqt" ];

  meta = with lib; {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}

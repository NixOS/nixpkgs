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
  version = "0.3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-nKNFV/mzdugQ+UJ/qB0SkCSm5vEpvI/tgHYKJr6NEyg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pyqt5
    qtpy
    typing-extensions
    pygments
  ];

  checkInputs = [ pytestCheckHook ];

  doCheck = false; # Segfaults...

  pythonImportsCheck = [ "superqt" ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}

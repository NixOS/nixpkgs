{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pyqt5
, typing-extensions
, pytest
, pytestCheckHook
}: buildPythonPackage rec {
  pname = "superqt";
  version = "0.2.5-1";
  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rkTiCJ8mIogS9SDmLPiaAyhhuBx3kk6rXjCc19zbwiM=";
  };
  format = "pyproject";
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ pyqt5 typing-extensions ];
  checkInputs = [ pytestCheckHook pytest ];
  doCheck = false; # Segfaults...
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}

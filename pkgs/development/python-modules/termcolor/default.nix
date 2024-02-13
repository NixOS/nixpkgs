{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qrnlYEfIrEHteY+jbYkqN6yms+kVnz4MJLxkqbOse3o=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [
    "termcolor"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Termcolor";
    homepage = "https://pypi.python.org/pypi/termcolor";
    license = licenses.mit;
  };

}

{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "2.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ayz3aekzZKJnbh3lanwM/yz1vQfzfpzICw3WMg6/44g=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [
    "termcolor"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Termcolor";
    homepage = "https://pypi.python.org/pypi/termcolor";
    license = licenses.mit;
  };

}

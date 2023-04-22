{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "4.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "typing_extensions";
    inherit version;
    hash = "sha256-XLX0p5E51plgez72IqHe2vqE4RWrACTg2cBEqUecp8s=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Tests are not part of PyPI releases. GitHub source can't be used
  # as it ends with an infinite recursion
  doCheck = false;

  pythonImportsCheck = [
    "typing_extensions"
  ];

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python 3.5+";
    homepage = "https://github.com/python/typing";
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}

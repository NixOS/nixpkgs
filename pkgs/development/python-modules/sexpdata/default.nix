{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b2XxFSkYkMvOXNJpwTvfH4KkzSO8YbbhUKJ1Ee5qfV4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [
    "sexpdata"
  ];

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

}

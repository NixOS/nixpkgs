{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3cIYLEKRKkQFEb1/9dPmocq8Osy8Z0oyWMjEHL+7ISU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "toposort"
  ];

  meta = with lib; {
    description = "A topological sort algorithm";
    homepage = "https://pypi.python.org/pypi/toposort/";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}

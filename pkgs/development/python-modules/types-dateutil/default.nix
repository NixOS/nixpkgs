{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.9.0.20240316";
  pyproject = true;

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-XS8uJAuGkF5AlE3Xh9ttqSY/Deq+8Qdt2u15c1HsAgI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "dateutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}

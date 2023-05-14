{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "5.9.5.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xsfmtBtvfruHr9VlDfNgdR0Ois8NJ2t6xk0A9Bm+uSI=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "psutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ anselmschueler ];
  };
}

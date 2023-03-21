{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-retry";
  version = "0.9.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VEgdUj/nvMXWujndTyBT5XUjoVoW4xK3yP6b5H/EVdU=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "retry-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

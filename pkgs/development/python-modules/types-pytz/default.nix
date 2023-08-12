{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2023.3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Nxw1UOq82FqfkhjFUOohPdCBfKEzv1mSd30TGqCCqw=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "pytz-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

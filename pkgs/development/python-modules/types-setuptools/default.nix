{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "57.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pGAO/cpoozIErZwIP9mWbWOu5hp9AH6RK2r8b/V9bgI=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

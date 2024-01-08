{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "69.0.0.20240106";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Hf5CJV43zyZOPbkqhYz8YK6Z0Cm/bEzPxYrrl38utw=";
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

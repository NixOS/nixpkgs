{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-retry";
  version = "0.9.9.20241221";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_retry";
    inherit version;
    hash = "sha256-661tSVpaBKsNBtQVamZVKMO4SoRhqgGd1uXT4zwqoeA=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "retry-stubs" ];

  meta = with lib; {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

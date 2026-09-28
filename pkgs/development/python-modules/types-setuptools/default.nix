{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "80.9.0.20251223";
  pyproject = true;

  src = fetchPypi {
    pname = "types_setuptools";
    inherit version;
    hash = "sha256-00EQWa4vXwOYUhfYasYITv6iyenKzV8Iae+VDzCBabI=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}

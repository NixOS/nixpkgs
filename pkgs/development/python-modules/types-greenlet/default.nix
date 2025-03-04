{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-greenlet";
  version = "3.1.0.20241221";
  pyproject = true;

  src = fetchPypi {
    pname = "types_greenlet";
    inherit version;
    hash = "sha256-e89X9T4QNsmsuULqh793bDmZXmM1ekUCVB7r5dsLWJc=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "greenlet-stubs" ];

  meta = {
    description = "Typing stubs for greenlet";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

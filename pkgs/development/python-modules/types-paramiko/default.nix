{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
}:
buildPythonPackage (finalAttrs: {
  pname = "types-paramiko";
  version = "5.0.0.20260724";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_paramiko";
    inherit (finalAttrs) version;
    hash = "sha256-N+fz8hls8YfIlkmtg2YhxnW8MYNp2A+ngFFQekrncMk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
  ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "paramiko-stubs" ];

  meta = {
    description = "Typing stubs for paramiko";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})

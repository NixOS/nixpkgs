{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  pysocks,
  stem,
}:

buildPythonPackage (finalAttrs: {
  pname = "torrequest";
  version = "0.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-N0XU6j/9qY16A0Njx4ets3qrd72rQAlKTZNzks1NroI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pysocks
    requests
    stem
  ];

  # This package does not contain any tests.
  doCheck = false;

  pythonImportsCheck = [ "torrequest" ];

  meta = {
    homepage = "https://github.com/erdiaker/torrequest";
    description = "Simple Python interface for HTTP(s) requests over Tor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ applePrincess ];
  };
})

{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  twisted,
  requests,
  cryptography,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "txrequests";
  version = "0.9.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tFKhyvpNAFZ49vpHkiozD+tJB9W0cy0YQcqY6J8TYuE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    twisted
    requests
    cryptography
  ];

  # Require network access
  doCheck = false;

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "txrequests" ];

  meta = {
    description = "Asynchronous Python HTTP for Humans";
    homepage = "https://github.com/tardyp/txrequests";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})

{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "webio-api";
  version = "0.1.12";
  pyproject = true;

  src = fetchPypi {
    pname = "webio_api";
    inherit version;
    hash = "sha256-xS1uf407+ommERkZSYrElD6/tNXyBma3OFs4jUE5+tY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "webio_api" ];

  meta = {
    description = "Simple API to use for communication with WebIO device meant for Home Assistant integration";
    homepage = "https://github.com/nasWebio/webio_api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}

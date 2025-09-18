{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "webio-api";
  version = "0.1.11";
  pyproject = true;

  src = fetchPypi {
    pname = "webio_api";
    inherit version;
    hash = "sha256-fPlAWu/P9gOjlQ62qAesLcLkNznAiMAAqxAlQi9oxZk=";
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

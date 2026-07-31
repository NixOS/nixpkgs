{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "streamlabswater";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kXG0Wg3PVryMBQ9RMMtEzudMiwVQq7Ikw2OK7JcBojA=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "streamlabswater" ];

  meta = {
    description = "Python library for the StreamLabs API";
    homepage = "https://github.com/streamlabswater/stream-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

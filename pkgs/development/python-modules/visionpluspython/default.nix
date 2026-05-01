{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pyjwt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "visionpluspython";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9tHjRWMVxi1diPlKGPXLRgi5rkuAXskStUBIqfO0oh4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "visionpluspython" ];

  meta = {
    description = "Python API wrapper for Watts Vision+ smart home system";
    homepage = "https://github.com/Watts-Digital/visionpluspython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}

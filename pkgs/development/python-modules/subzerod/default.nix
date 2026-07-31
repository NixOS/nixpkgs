{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "subzerod";
  version = "1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/7g8Upj9Hb4m83JXLI3X2lqa9faCt42LVxh+V9WpI68=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "subzerod" ];

  meta = {
    description = "Python module to help with the enumeration of subdomains";
    mainProgram = "subzerod";
    homepage = "https://github.com/sanderfoobar/subzerod";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ fab ];
  };
}

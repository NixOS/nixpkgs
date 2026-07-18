{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  isPy3k,
}:

buildPythonPackage (finalAttrs: {
  pname = "web-cache";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  disabled = !isPy3k;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "web_cache";
    hash = "sha256-1aEKNMh77/x5S44d7He/a0GYhrnMYLmxDHBoEIcODrU=";
  };

  build-system = [ setuptools ];

  # No tests in downloaded archive
  doCheck = false;

  pythonImportsCheck = [ "web_cache" ];

  meta = {
    description = "Simple Python key-value storage backed up by sqlite3 database";
    homepage = "https://github.com/desbma/web_cache";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ moni ];
  };
})

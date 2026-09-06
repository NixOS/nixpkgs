{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "zalgolib";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ne2gT5OBoKkNZP70DjUZSE8n2HNvdgb/PSLdDrF+fs0=";
  };

  build-system = [ setuptools ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "zalgolib" ];

  meta = {
    description = "Python library for Zalgo";
    homepage = "https://pypi.org/project/zalgolib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

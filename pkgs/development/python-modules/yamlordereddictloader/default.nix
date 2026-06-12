{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "yamlordereddictloader";
  version = "0.4.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Nq8vYhD8/12k/EwS4dgV+XPc60EETnleHwYRXWNLyhM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "yamlordereddictloader" ];

  meta = {
    description = "YAML loader and dump for PyYAML allowing to keep keys order";
    homepage = "https://github.com/fmenabe/python-yamlordereddictloader";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})

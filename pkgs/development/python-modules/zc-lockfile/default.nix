{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "zc-lockfile";
  version = "4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zc.lockfile";
    inherit version;
    hash = "sha256-06sPU5dClqgG2zIZuRkboObVy70dqi4NFyCMubKdIQI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zc.lockfile" ];

  nativeCheckInputs = [
    pytestCheckHook
    zope-testing
  ];

  enabledTestPaths = [ "src/zc/lockfile/tests.py" ];

  pythonNamespaces = [ "zc" ];

  meta = {
    description = "Inter-process locks";
    homepage = "https://www.python.org/pypi/zc.lockfile";
    changelog = "https://github.com/zopefoundation/zc.lockfile/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}

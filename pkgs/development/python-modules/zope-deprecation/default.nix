{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-deprecation";
  version = "5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.deprecation";
    inherit version;
    hash = "sha256-Rr7UYR+1PtxzGq3rZLKDCLy4SPTMFQxgyUjQePcQhyE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "src/zope/deprecation/tests.py" ];

  pythonImportsCheck = [ "zope.deprecation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.deprecation";
    description = "Zope Deprecation Infrastructure";
    changelog = "https://github.com/zopefoundation/zope.deprecation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}

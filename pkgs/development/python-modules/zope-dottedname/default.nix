{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-dottedname";
  version = "6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.dottedname";
    inherit version;
    hash = "sha256-28S4W/vzSx74jasWJSrG7xbZBDnyIjstCiYs9Bnq6QI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/dottedname/tests.py" ];

  pythonImportsCheck = [ "zope.dottedname" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.dottedname";
    description = "Resolver for Python dotted names";
    changelog = "https://github.com/zopefoundation/zope.dottedname/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}

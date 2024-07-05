{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-cachedescriptors";
  version = "5.0";

  format = "setuptools";

  src = fetchPypi {
    pname = "zope.cachedescriptors";
    inherit version;
    hash = "sha256-MVe+hm/Jck0Heotb9sP8IcOKQUerZk5yRiLf5fr/BIo=";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "src/zope/cachedescriptors/tests.py" ];

  pythonImportsCheck = [ "zope.cachedescriptors" ];

  meta = {
    description = "Method and property caching decorators";
    homepage = "https://github.com/zopefoundation/zope.cachedescriptors";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

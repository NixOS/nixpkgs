{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-cachedescriptors";
  version = "4.3.1";

  format = "setuptools";

  src = fetchPypi {
    pname = "zope.cachedescriptors";
    inherit version;
    sha256 = "1f4d1a702f2ea3d177a1ffb404235551bb85560100ec88e6c98691734b1d194a";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/zope/cachedescriptors/tests.py"
  ];

  pythonImportsCheck = [ "zope.cachedescriptors" ];

  meta = {
    description = "Method and property caching decorators";
    homepage = "https://github.com/zopefoundation/zope.cachedescriptors";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

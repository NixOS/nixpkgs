{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-cachedescriptors";
  version = "4.4";

  format = "setuptools";

  src = fetchPypi {
    pname = "zope.cachedescriptors";
    inherit version;
    sha256 = "sha256-1FxIdIb334HymS8aAJEmJL93JZ2DxdmKp2tnhxbj0Ro=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
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

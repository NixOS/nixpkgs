{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-dottedname";
  version = "6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.dottedname";
    inherit version;
    hash = "sha256-28S4W/vzSx74jasWJSrG7xbZBDnyIjstCiYs9Bnq6QI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/zope/dottedname/tests.py"
  ];

  pythonImportsCheck = [
    "zope.dottedname"
  ];

  pythonNamespaces = [
    "zope"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.dottedname";
    description = "Resolver for Python dotted names";
    changelog = "https://github.com/zopefoundation/zope.dottedname/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}

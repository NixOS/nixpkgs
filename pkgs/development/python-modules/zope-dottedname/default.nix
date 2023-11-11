{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-dottedname";
  version = "5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.dottedname";
    inherit version;
    hash = "sha256-mfWDqAKFhqtMIXlGE+QR0BDNCZF/RdqXa9/udI87++w=";
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

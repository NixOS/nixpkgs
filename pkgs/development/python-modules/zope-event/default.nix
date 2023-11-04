{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-event";
  version = "4.6";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.event";
    inherit version;
    hash = "sha256-gdmIEwRvyGzEE242mP7mKKMoL5wyDbGGWMIXSSNfzoA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/zope/event/tests.py"
  ];

  pythonImportsCheck = [
    "zope.event"
  ];

  pythonNamespaces = [
    "zope"
  ];

  meta = with lib; {
    description = "An event publishing system";
    homepage = "https://pypi.org/project/zope.event/";
    changelog = "https://github.com/zopefoundation/zope.event/blob/${src}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}

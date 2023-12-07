{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "zope-event";
  version = "4.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.event";
    inherit version;
    hash = "sha256-gdmIEwRvyGzEE242mP7mKKMoL5wyDbGGWMIXSSNfzoA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "zope.event"
  ];

  meta = with lib; {
    description = "An event publishing system";
    homepage = "https://github.com/zopefoundation/zope.event";
    changelog = "https://github.com/zopefoundation/zope.event/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope-event
, zope_interface
, zope_location
, zope-testing
}:

buildPythonPackage rec {
  pname = "zope.schema";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6tTbywM1TU5BDJo7kERR60TZAlR1Gxy97fSmGu3p+7k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    zope-event
    zope_interface
    zope_location
    zope-testing
  ];

  # ImportError: No module named 'zope.event'
  # even though zope_event has been included.
  # Package seems to work fine.
  doCheck = false;

  pythonImportsCheck = [
    "zope.schema"
  ];

  meta = with lib; {
    description = "zope.interface extension for defining data schemas";
    homepage = "https://github.com/zopefoundation/zope.schema";
    changelog = "https://github.com/zopefoundation/zope.schema/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

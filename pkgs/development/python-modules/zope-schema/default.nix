{ lib
, buildPythonPackage
, fetchPypi
, zope-location
, zope-event
, zope-interface
, zope-testing
}:

buildPythonPackage rec {
  pname = "zope.schema";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6tTbywM1TU5BDJo7kERR60TZAlR1Gxy97fSmGu3p+7k=";
  };

  propagatedBuildInputs = [ zope-location zope-event zope-interface zope-testing ];

  # ImportError: No module named 'zope.event'
  # even though zope-event has been included.
  # Package seems to work fine.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.schema";
    description = "zope.interface extension for defining data schemas";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

{ lib
, buildPythonPackage
, fetchPypi
, zope_location
, zope_event
, zope_interface
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.schema";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2201aef8ad75ee5a881284d7a6acd384661d6dca7bde5e80a22839a77124595b";
  };

  propagatedBuildInputs = [ zope_location zope_event zope_interface zope_testing ];

  # ImportError: No module named 'zope.event'
  # even though zope_event has been included.
  # Package seems to work fine.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.schema";
    description = "zope.interface extension for defining data schemas";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

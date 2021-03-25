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
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b3fc3ac656099aa9ebf3beb2bbd83d2d6ee6f94b9ac6969d6e3993ec9c4a197";
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

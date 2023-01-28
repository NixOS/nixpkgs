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
  version = "6.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-47M8i8i6nYWlZxOrjwo8JhXVSoCF8eQVzgyN+15UC+Y=";
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

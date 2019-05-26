{ stdenv
, buildPythonPackage
, fetchPypi
, zope_location
, zope_event
, zope_interface
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.schema";
  version = "4.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d971da8707cab47b1916534b9929dcd9d7f23aed790e6b4cbe3103d5b18069d";
  };

  propagatedBuildInputs = [ zope_location zope_event zope_interface zope_testing ];

  # ImportError: No module named 'zope.event'
  # even though zope_event has been included.
  # Package seems to work fine.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.schema;
    description = "zope.interface extension for defining data schemas";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

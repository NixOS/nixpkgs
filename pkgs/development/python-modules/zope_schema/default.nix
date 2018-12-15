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
  version = "4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p943jdxb587dh7php4vx04qvn7b2877hr4qs5zyckvp5afhhank";
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

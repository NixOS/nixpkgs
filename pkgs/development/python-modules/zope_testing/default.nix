{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, zope_interface
, zope_exceptions
, zope_location
}:

buildPythonPackage rec {
  pname = "zope.testing";
  version = "4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "475cb847a7af9d547313ee93f5d0b8800bf627e6d0d9a51d11967984083cb54e";
  };

  doCheck = !isPyPy;

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_location ];

  meta = with lib; {
    description = "Zope testing helpers";
    homepage =  "http://pypi.python.org/pypi/zope.testing";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

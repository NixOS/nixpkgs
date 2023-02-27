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
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6HzQ2NZmVzza8TOBare5vuyAGmSoZZXBnLX+mS7z1kk=";
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

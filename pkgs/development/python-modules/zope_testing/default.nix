{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, zope_interface
, zope_exceptions
, zope_location
}:

buildPythonPackage rec {
  pname = "zope.testing";
  version = "4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d66be8d1de37e8536ca58a1d9f4d89a68c9cc75cc0e788a175c8a20ae26003ea";
  };

  doCheck = !isPyPy;

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_location ];

  meta = with stdenv.lib; {
    description = "Zope testing helpers";
    homepage =  http://pypi.python.org/pypi/zope.testing;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

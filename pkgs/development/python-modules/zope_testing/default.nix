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
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vvxhjmzl7vw2i1akfj1xbggwn36270ym7f2ic9xwbaswfw1ap56";
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

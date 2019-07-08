{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.dottedname";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cec09844d309550359ac1941abfcd9141e213f67f3c19bb8f90360c40787576";
  };

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/zope.dottedname;
    description = "Resolver for Python dotted names";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

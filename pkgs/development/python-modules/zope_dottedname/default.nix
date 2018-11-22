{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.dottedname";
  version = "3.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "331d801d98e539fa6c5d50c3835ecc144c429667f483281505de53fc771e6bf5";
  };

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/zope.dottedname;
    description = "Resolver for Python dotted names";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

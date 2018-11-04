{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.exceptions";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fa59c3c1044bb9448aeec8328db0bfceaae2a2174e88528d3fe04adf8d47211";
  };

  propagatedBuildInputs = [ zope_interface ];

  # circular deps
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Exception interfaces and implementations";
    homepage = https://pypi.python.org/pypi/zope.exceptions;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}

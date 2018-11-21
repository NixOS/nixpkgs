{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.exceptions";
  version = "4.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zwxaaa66sqxg5k7zcrvs0fbg9ym1njnxnr28dfmchzhwjvwnfzl";
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

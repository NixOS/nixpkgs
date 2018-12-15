{ stdenv
, buildPythonPackage
, fetchPypi
, testtools
}:

buildPythonPackage rec {
  pname = "testscenarios";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1671jvrvqlmbnc42j7pc5y6vc37q44aiwrq0zic652pxyy2fxvjg";
  };

  propagatedBuildInputs = [ testtools ];

  meta = with stdenv.lib; {
    description = "A pyunit extension for dependency injection";
    homepage = https://pypi.python.org/pypi/testscenarios;
    license = licenses.asl20;
  };

}

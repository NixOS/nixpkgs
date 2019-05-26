{ stdenv, buildPythonPackage, fetchPypi
, requests, six
, backports_unittest-mock, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b4c5119b9381cb6ddaf3236f3f7e1437a14e488d1ed61336873a839788481b0";
  };

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ backports_unittest-mock pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Client library for reading Server Sent Event streams";
    homepage = https://github.com/btubbs/sseclient;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
